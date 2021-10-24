import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:convert' as json;
import 'dart:io';
import 'dart:math';

import 'package:dor_chat_client/models/settings_model.dart';
import 'package:dor_chat_client/models/users_model.dart';
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





  postUserSettings() async {
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



}
