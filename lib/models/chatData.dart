import 'dart:async';
import 'dart:math';
import 'package:dor_chat_client/models/persistentMessagesData.dart';
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


Future<void> handleBackgroundMessage(RemoteMessage message)async{
  print('Persisting should sync because got $message');
  PersistMessages().writeShouldSync(true);
}

class ChatData extends ChangeNotifier{

  static const CONVERSATIONS_BOXNAME = 'conversations';
  static const USERS_BOXNAME = 'users';
  Map<String,Tuple2<ValueListenable<Box>,int>> listenedValues = {};
  Map<String,bool> markingConversation = {};


  void addMessageToDB(InfoMessage messageReceived){
    final String conversationId = messageReceived.conversationId;
    final InfoConversation? existingConversation = conversationsBox.get(conversationId);
    if(existingConversation==null){
      //print('Conversation doesnt exist. creating conversation..');
      final messages = [messageReceived];
      final List<String> participantsIds = List.from(Set.from([messageReceived.userId,SettingsData().facebookId])); //TODO to support groups make sure the list of participants is also sent with server and appropriately update it here...
      conversationsBox.put(conversationId,InfoConversation(conversationId: conversationId, lastChangedTime: 0, creationTime: 0, participantsIds: participantsIds, messages: messages));
    return;
    }
    //Conversation exists so update messages and participants etc
      //print('Conversation exists. Updating conversation');
      var messages = existingConversation.messages;
      final int indexOldMessage = messages.indexWhere((message) => message.messageId == messageReceived.messageId);
      if(indexOldMessage<0){
        //print("Message didn't exist");
        messages.insert(0, messageReceived);
      }

      else{
        //print('Message existed so just updating message...');
        if (messages[indexOldMessage]!=messageReceived) //TODO pointless as long as I don't implement operator ==
        {

          InfoMessage currentDbMessage = messages[indexOldMessage];
          //TODO combine currentDbMessage and messageReceived
          var currentReceipts = currentDbMessage.receipts;
          var receivedReceipts = messageReceived.receipts;
          for(var key in receivedReceipts.keys){
              if(currentReceipts.keys.contains(key)){
              currentReceipts[key]!.sentTime = max(receivedReceipts[key]!.sentTime,currentReceipts[key]!.sentTime);
              currentReceipts[key]!.readTime = max(receivedReceipts[key]!.readTime,currentReceipts[key]!.readTime);}

              else{
                currentReceipts[key] = receivedReceipts[key]!;
              }
            }

          InfoMessage updatedMessage = InfoMessage(content: messageReceived.content, messageId: messageReceived.messageId, conversationId: messageReceived.conversationId, userId: messageReceived.userId, receipts: currentReceipts,messageStatus: messageReceived.messageStatus,readTime: messageReceived.readTime,sentTime: messageReceived.sentTime,addedDate: messageReceived.addedDate,changedDate: messageReceived.changedDate);
          messages[indexOldMessage] = updatedMessage;
          }
          print('Dor');


        }
    messages.sort((messageA,messageB)=> (messageB.addedDate??0)>(messageA.addedDate??0)?1:-1);
      List<String> participantsIds = existingConversation.participantsIds;
      participantsIds = List.from(Set.from([SettingsData().facebookId,messageReceived.userId,...participantsIds]));
      InfoConversation updatedConversation = InfoConversation(conversationId: existingConversation.conversationId,
          lastChangedTime: existingConversation.lastChangedTime, creationTime: existingConversation.creationTime, participantsIds: participantsIds, messages: messages); //TODO notice that changed time is complete bullshit for now
      conversationsBox.put(conversationId,updatedConversation);

  }

  void updateDatabaseOnMessage(message) {
    if(message['push_notification_type']=='new_read_receipt'){
      //TODO for now just sync with server "everything" there is to sync. Of course,this can be improved if and when necessary
      syncWithServer();
      return;
    }
    final String senderId = message['user_id'];
      if(senderId!=SettingsData().facebookId){ //Update Users Box
        final InfoUser sender = InfoUser.fromJson(jsonDecode(message["sender_details"]));
        usersBox.put(sender.facebookId, sender); //Update users box
      }
      final InfoMessage messageReceived = InfoMessage.fromJson(message);
      addMessageToDB(messageReceived);
      notifyListeners();
      syncWithServer();
  }

  Future<void> syncWithServer() async{
    List<InfoMessage> newMessages = await NetworkHelper.getMessagesByTimestamp();
    print('got ${newMessages.length} new messages from server while syncing');
    double maxTimestampSeen =0.0;
    for(final message in newMessages){
      addMessageToDB(message);
      maxTimestampSeen = max(maxTimestampSeen,message.changedDate??message.sentTime??0);
    }


    if(SettingsData().lastSync<maxTimestampSeen){
      print('setting last sync to be $maxTimestampSeen');
      SettingsData().lastSync = maxTimestampSeen;
    }
  }


  //Make it a singleton
  ChatData._privateConstructor() {
    _fcmStream.listen(updateDatabaseOnMessage);
    syncWithServer(); //Sync with the server (once,it's a singleton..) as soon as the app starts
  }
  static final ChatData _instance = ChatData._privateConstructor();


  String calculateConversationId(String otherUserId){
    String userId1 = SettingsData().facebookId;
    String userId2 = otherUserId;
    if (userId1.compareTo(userId2)>0){
      var temp = userId1; //Swap...
      userId1 = userId2;
      userId2=temp;
    }

    return 'conversation_${userId1}_with_$userId2';
  }

  String calculateMessageId(String conversationId,double epochTime){
    return SettingsData().facebookId + '_' + conversationId + '_' + epochTime.toString();
  }
  
  
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


  void sendMessage(String otherUserId,String messageContent) async{
    double epochTime = DateTime.now().millisecondsSinceEpoch/100;
    String conversationId = calculateConversationId(otherUserId);
    String messageId = calculateMessageId(conversationId, epochTime);
    InfoMessage newMessage = InfoMessage(content: messageContent,messageId: messageId,conversationId: conversationId,userId: SettingsData().facebookId,messageStatus: 'Uploading',receipts: {},changedDate: epochTime,addedDate: epochTime);
    addMessageToDB(newMessage);
    await NetworkHelper.sendMessage(otherUserId,messageContent,epochTime);
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
        FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
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

  Future<void> markConversationAsRead(String conversationId) async{
    if(markingConversation.containsKey(conversationId) && markingConversation[conversationId]==true){
      return;
    }


    String currentUserId = SettingsData().facebookId;
    InfoConversation? theConversation = conversationsBox.get(conversationId);
    if(theConversation == null) {return;}

    for(var message in theConversation.messages){
      var sender = message.userId;
      if(sender==SettingsData().facebookId){continue;}
      //We got to the first message not by the user. Since messages are sorted by change date, this is the most recent message
      if(!message.receipts.containsKey(currentUserId) || message.receipts[currentUserId]!.readTime==0){
        markingConversation[conversationId] = true;
        await NetworkHelper.markConversationAsRead(conversationId);
        Timer(Duration(seconds: 1),(){markingConversation[conversationId]=false;});

      }
      return;
    }



  }



}