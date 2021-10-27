import 'dart:async';

import 'package:dor_chat_client/models/infoConversation.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/services/networking.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';









class Users extends ChangeNotifier{



  //Make it a singleton
  Users._privateConstructor() {
    _fcmStream.listen((message) {
      print('Got the message $message');
    });
  }
  static final Users _instance = Users._privateConstructor();

  factory Users() {
    return _instance;
  }

  List <InfoUser> _usersAvailableChat = [];
  List <InfoConversation> _conversations = [];
  Stream<dynamic> _fcmStream = createStream();

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
              print('Got a message whilst in the foreground!');
              print('Message data: ${message.data['dor_text']}');

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