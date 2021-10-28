import 'dart:async';
import 'dart:math';
import 'package:tuple/tuple.dart';
import 'package:dor_chat_client/models/infoConversation.dart';
import 'package:dor_chat_client/models/infoMessage.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/services/networking.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';


class ChatData extends ChangeNotifier{

  static const CONVERSATIONS_BOXNAME = 'conversations';
  static const USERS_BOXNAME = 'users';
  Map<String,Tuple2<ValueListenable<Box>,int>> listenedValues = {};


  void addMessageToDB(InfoMessage messageReceived){
    final String conversationId = messageReceived.conversationId;
    final InfoConversation? existingConversation = conversationsBox.get(conversationId);
    if(existingConversation==null){
      print('Conversation doesnt exist. creating conversation..');
      final messages = [messageReceived];
      final List<String> participantsIds = List.from(Set.from([messageReceived.userId,SettingsData().facebookId])); //TODO to support groups make sure the list of participants is also sent with server and appropriately update it here...
      conversationsBox.put(conversationId,InfoConversation(conversationId: conversationId, lastChangedTime: 0, creationTime: 0, participantsIds: participantsIds, messages: messages));
    }
    else{//Conversation exists so update messages and participants etc
      print('Conversation exists. Updating conversation');
      var messages = existingConversation.messages;
      final int indexOldMessage = messages.indexWhere((message) => message.messageId == messageReceived.messageId);
      if(indexOldMessage<0){
        print("Message didn't exist");
        messages.insert(0, messageReceived);
        messages.sort((messageA,messageB)=> (messageB.sentTime??0)>(messageA.sentTime??0)?1:-1);
      }

      else{
        print('Message existed so just updating message...');
        if(messages[indexOldMessage]!=messageReceived)
        {
          messages[indexOldMessage] = messageReceived;}
      }
      List<String> participantsIds = existingConversation.participantsIds;
      participantsIds = List.from(Set.from([SettingsData().facebookId,messageReceived.userId,...participantsIds]));
      InfoConversation updatedConversation = InfoConversation(conversationId: existingConversation.conversationId,
          lastChangedTime: existingConversation.lastChangedTime, creationTime: existingConversation.creationTime, participantsIds: participantsIds, messages: messages); //TODO notice that changed time is complete bullshit for now
      conversationsBox.put(conversationId,updatedConversation);

    }
  }

  void updateDatabaseOnMessage(message) {
      final String senderId = message['facebook_id'];
      if(senderId!=SettingsData().facebookId){ //Update Users Box
        final InfoUser sender = InfoUser.fromJson(jsonDecode(message["sender_details"]));
        usersBox.put(sender.facebookId, sender); //Update users box
      }
      final InfoMessage messageReceived = InfoMessage.fromJson(message);
      addMessageToDB(messageReceived);
      //await syncWithServer();
      notifyListeners();
  }

  Future<void> syncWithServer() async{
    List<InfoMessage> newMessages = await NetworkHelper.syncChatData();
    print('got ${newMessages.length} new messages from server while syncing');
    double maxTimestampSeen =0.0;
    for(final message in newMessages){
      addMessageToDB(message);
      maxTimestampSeen = max(maxTimestampSeen,message.changedDate??message.sentTime??0);
    }
    if(SettingsData().lastSync<maxTimestampSeen){
      SettingsData().lastSync = maxTimestampSeen;
    }
  }


  //Make it a singleton
  ChatData._privateConstructor() {
    _fcmStream.listen(updateDatabaseOnMessage);
    syncWithServer(); //Sync with the server (once,it's a singleton..) as soon as the app starts
  }
  static final ChatData _instance = ChatData._privateConstructor();
  
  
  void listenConversation(String conversationId,VoidCallback listener){
    if(!listenedValues.containsKey(conversationId)){
      listenedValues[conversationId] =  Tuple2(conversationsBox.listenable(keys:[conversationId]),0);
    }
    listenedValues[conversationId]!.item1.addListener(listener);
    listenedValues[conversationId]!.withItem2(listenedValues[conversationId]!.item2+1);
  }

  void removeListenerConversation(String conversationId,VoidCallback listener){
    if(listenedValues.containsKey(conversationId)){
      print('actually removing listener');
      listenedValues[conversationId]!.item1.removeListener(listener);
      listenedValues[conversationId]!.withItem2(listenedValues[conversationId]!.item2-1);
      print(listenedValues[conversationId]!.item2);
      if(listenedValues[conversationId]!.item2<=0){
        print('removing from map');
        listenedValues.remove(conversationId);
      }
    }
  }

  factory ChatData() {
    return _instance;
  }
  List <InfoConversation> _conversations = [];
  Stream<dynamic> _fcmStream = createStream();
  Box<InfoConversation> conversationsBox = Hive.box(CONVERSATIONS_BOXNAME);
  Box<InfoUser> usersBox = Hive.box(USERS_BOXNAME);

  getUsersFromServer() async{
    List<InfoUser> gottenUsers = await NetworkHelper.getAllUsers();
    for(var user in gottenUsers){
      usersBox.put(user.facebookId,user);
    }
    notifyListeners();
  }


  void sendMessage(String facebookUserId,String messageContent) async{
    await NetworkHelper.sendMessage(facebookUserId,messageContent);
    return;

  }



  List<InfoUser> get users{
    return List.unmodifiable(usersBox.values);
  }

  InfoUser? getUserById(String userId){
    return usersBox.get(userId);
  }

  List<InfoMessage> messagesInConversation(String conversationId){
    InfoConversation? foundConversation = conversationsBox.get(conversationId);
    if(foundConversation==null){return [];}
    return foundConversation.messages;
  }


  static Stream<dynamic> createStream(){
    late StreamController<dynamic> controller;
    StreamSubscription? subscription;
    void setFirebaseEvents() {
      if (subscription == null) {
        subscription =
            FirebaseMessaging.onMessage.listen((RemoteMessage message) {
              print('Got a message while in the foreground!');
              if (message.notification != null) {
                print('Message also contained a notification: ${message
                    .notification}');
              }
              controller.add(message.data);
            });
      }
    }
    void unsetFirebaseEvents(){
      if(subscription!=null){
        subscription!.cancel();
        subscription = null;
      }
    }

    controller = StreamController<dynamic>(
        onListen: setFirebaseEvents,
        onPause: unsetFirebaseEvents,
        onResume: setFirebaseEvents,
        onCancel: unsetFirebaseEvents);

    return controller.stream;



  }



}