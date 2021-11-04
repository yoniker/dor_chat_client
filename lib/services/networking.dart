import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:convert' as json;
import 'dart:io';
import 'dart:math';

import 'package:dor_chat_client/models/infoConversation.dart';
import 'package:dor_chat_client/models/infoMessage.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/models/chatData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


enum NetworkTaskStatus { completed, inProgress, notExist } //possible statuses for long ongoing tasks on the server

class NetworkHelper {
  static const SERVER_ADDR = 'dordating.com:8085';
  static final NetworkHelper _instance = NetworkHelper._internal();
  static const MIN_TASK_STATUS_CALL_INTERVAL = Duration(seconds: 1);

  factory NetworkHelper() {
    return _instance;
  }

  NetworkHelper._internal();

  static Future<List<InfoUser>> getAllUsers() async {
    Uri usersLinkUri = Uri.https(SERVER_ADDR, 'users/${SettingsData().facebookId}');
    http.Response resp = await http.get(usersLinkUri);
    if (resp.statusCode == 200) {
      //TODO think how to handle network errors
      List<dynamic> parsed = json.jsonDecode(resp.body);
      List<InfoUser> users = parsed.map((e) => InfoUser.fromJson(e)).toList();
      return users;
    }

    return [];
  }


  static Future<List<InfoConversation>> getAllConversations() async {
    Uri chatDataLinkUri = Uri.https(SERVER_ADDR, 'chatData/${SettingsData().facebookId}');
    http.Response resp = await http.get(chatDataLinkUri);
    if (resp.statusCode == 200) {
      //TODO think how to handle network errors
      List<dynamic> parsed = json.jsonDecode(resp.body);
      print('Dor');
      //List<InfoUser> users = parsed.map((e) => InfoUser.fromJson(e)).toList();
      //return users;
      return [];
    }

    return [];
  }





  static postUserSettings() async {
    SettingsData settings = SettingsData();
    Map<String, String> toSend = {
      SettingsData.NAME_KEY: settings.name,
      SettingsData.FCM_TOKEN_KEY: settings.fcmToken,
      SettingsData.FACEBOOK_ID_KEY : settings.facebookId,
      SettingsData.FACEBOOK_PROFILE_IMAGE_URL_KEY:settings.facebookProfileImageUrl,
    };
    String encoded = jsonEncode(toSend);
    Uri postSettingsUri =
    Uri.https(SERVER_ADDR, '/register/${settings.facebookId}');
    print('sending user data...');
    http.Response response = await http.post(postSettingsUri,
        body: encoded); //TODO something if response wasnt 200
    if (response.statusCode == 200){
      SettingsData().registered = true;
    }
  }

  static Future<void> sendMessage(String facebookUserId,String startingConversationContent) async{
    Map<String, String> toSend = {
      'other_user_id':facebookUserId,
      'first_message':startingConversationContent
    };
    String encoded = jsonEncode(toSend);
    Uri postConversationUri =
    Uri.https(SERVER_ADDR, '/send_message/${SettingsData().facebookId}');
    print('starting conversation...');
    http.Response response = await http.post(postConversationUri, body: encoded);
    print('Dor is the king');
  }

  static Future<List<InfoMessage>> getMessagesByTimestamp()async{
    print('going to sync with ${SettingsData().lastSync}');
    Uri syncChatDataUri = Uri.https(SERVER_ADDR, '/sync/${SettingsData().facebookId}/${SettingsData().lastSync}');
    http.Response response = await http.get(syncChatDataUri);
    List<dynamic> unparsedMessages = json.jsonDecode(response.body);
    List<InfoMessage> messages = unparsedMessages.map((message) => InfoMessage.fromJson(message)).toList();
    print('dor?');
    return messages;

  }

  static Future<void> markConversationAsRead(String conversationId) async{
    Uri syncChatDataUri = Uri.https(SERVER_ADDR, '/mark_conversation_read/${SettingsData().facebookId}/$conversationId');
    http.Response response = await http.get(syncChatDataUri); //TODO something when there's an error
    return;
  }



}
