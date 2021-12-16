import 'package:dor_chat_client/models/chatData.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/screens/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert' as json;

import 'package:get/get.dart';


enum NotificationType {
  newMessage,
  newMatch,
}

class NotificationsController with WidgetsBindingObserver{

  static const String NEW_MESSAGE_NOTIFICATION = 'new_message_notification';
  static const String NOTIFICATION_TYPE = 'notification_type';
  static const String SENDER_ID = 'sender_id';
  AppLifecycleState _appState=AppLifecycleState.resumed;

  AppLifecycleState get appState => _appState;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appState = state;
    print('NOTIFICATIONS CENTRE App changed state; New state is $state');
  }
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationsController._privateConstructor(){
    WidgetsBinding.instance!.addObserver(this);
  }

  static final NotificationsController instance = NotificationsController._privateConstructor();

  Future selectNotification(String? payload) async {
    if(payload==null){return;}
    Map<String,dynamic> handleNotificationData = json.jsonDecode(payload);
    if(handleNotificationData[NOTIFICATION_TYPE]==NEW_MESSAGE_NOTIFICATION){
      String senderId = handleNotificationData[SENDER_ID]!;
      InfoUser? collocutor = ChatData().getUserById(senderId);
      if(collocutor!=null){
        navigator!.pushNamed(ChatScreen.routeName,arguments: collocutor);
      }

    }

  }

  void requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }



  Future<void> initialize()async{
  final AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );


  final InitializationSettings initializationSettings =
  InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification
  );

  }

  Future<void> showNewMessageNotification(
  {required String senderName, required String senderId}
      )async{
    if(_appState==AppLifecycleState.resumed){return;} //Don't show this notification if app is in foreground
    const AndroidNotificationDetails _androidNotificationDetails =
    AndroidNotificationDetails(
      'DorChat channel ID',
      'DorChat channel name',
      channelDescription: 'DorChat channel description',
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );

    const IOSNotificationDetails _iOSNotificationDetails =
    IOSNotificationDetails(threadIdentifier: 'DorChat_thread_id');


    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(
        android: _androidNotificationDetails,
        iOS: _iOSNotificationDetails);

    Map<String,String> payloadData = {
      NOTIFICATION_TYPE:NEW_MESSAGE_NOTIFICATION,
      SENDER_ID:senderId
    };
    
    await flutterLocalNotificationsPlugin.show(
      0,
      'ChatDor',
      'You got a new message from $senderName',
      platformChannelSpecifics,
      payload: json.jsonEncode(payloadData),
    );

  }





}