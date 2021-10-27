import 'dart:async';

import 'package:dor_chat_client/models/infoConversation.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/services/networking.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class ChatData extends ChangeNotifier{

  static const CONVERSATIONS_BOXNAME = 'conversations';
  static const USERS_BOXNAME = 'users';


  Future<void> initDatabase() async{
    conversationsBox = await Hive.openBox(CONVERSATIONS_BOXNAME);
    usersBox = await Hive.openBox(USERS_BOXNAME);
  }
  //Make it a singleton
  ChatData._privateConstructor() {
    initDatabase();
    _fcmStream.listen((message) {
      print('Got the message $message'); //TODO update database,datastructure and listeners
      print('king');
    });
  }
  static final ChatData _instance = ChatData._privateConstructor();

  factory ChatData() {
    return _instance;
  }

  List <InfoUser> _usersAvailableChat = [];
  List <InfoConversation> _conversations = [];
  Stream<dynamic> _fcmStream = createStream();
  late Box conversationsBox;
  late Box usersBox;

  updateUsers() async{
    List<InfoUser> gottenUsers = await NetworkHelper.getAllUsers();
    _usersAvailableChat = gottenUsers;
    notifyListeners();
  }

  updateConversations() async{
    List<InfoConversation> gottenConversations = await NetworkHelper.getAllConversations();
  }

  Future<InfoConversation> startConversation(String facebookUserId,String startingMessageContent) async{
    List existingConversations = _conversations.where((conversation) => conversation.participants.length == 1 && conversation.participants.first == facebookUserId).toList();
    if(existingConversations.length>=1) {return existingConversations.first;}
    return await NetworkHelper().startConversation(facebookUserId,startingMessageContent);

  }



  List<InfoUser> get users{
    return _usersAvailableChat;
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