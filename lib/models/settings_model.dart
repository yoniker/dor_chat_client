import 'dart:async';
import 'package:dor_chat_client/services/networking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData extends ChangeNotifier{
  //Some consts to facilitate share preferences access
  static const String NAME_KEY = 'name';
  static const String FACEBOOK_ID_KEY = 'facebook_id';
  static const String FACEBOOK_PROFILE_IMAGE_URL_KEY = 'facebook_profile_image_url';
  static const String FCM_TOKEN_KEY = 'fcm_token';
  static const String REGISTERED_KEY = 'is_registered';
  static const _debounceSettingsTime = Duration(seconds: 2); //Debounce time such that we notify listeners
  String _name='';
  String _facebookId='';
  String _facebookProfileImageUrl = 'https://lunada.co.il/wp-content/uploads/2016/04/12198090531909861341man-silhouette.svg_.hi_-300x284.png';
  String _fcmToken = '';
  bool _readFromShared=false;
  bool _registered = false;
  Timer? _debounce;

  SettingsData._privateConstructor(){
    //Read settings from shared
    readSettingsFromShared();

  }
  
  bool canRegister(){
    return _facebookId.length > 0 && _name.length > 0 &&
        _facebookProfileImageUrl.length > 0 && _fcmToken.length > 0;
    
  }

  Future<void> readSettingsFromShared() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _name = sharedPreferences.getString(NAME_KEY) ?? _name;
    _facebookId = sharedPreferences.getString(FACEBOOK_ID_KEY) ?? _facebookId;
    _facebookProfileImageUrl = sharedPreferences.getString(FACEBOOK_PROFILE_IMAGE_URL_KEY) ?? _facebookProfileImageUrl;
    _fcmToken = sharedPreferences.getString(FCM_TOKEN_KEY) ?? _fcmToken;
    _registered = sharedPreferences.getBool(REGISTERED_KEY) ?? _registered;
    _readFromShared = true;
    return;
  }



  static final SettingsData _instance = SettingsData._privateConstructor();

  factory SettingsData() {
    return _instance;
  }

  bool get readFromShared{
    return _readFromShared;
  }


  String get name{
    return _name;
  }

  set name(String newName){
    _name = newName;
    savePreferences(NAME_KEY, newName);
  }


  String get facebookId{
    return _facebookId;
  }

  set facebookId(String newFacebookId){
    _facebookId = newFacebookId;
    savePreferences(FACEBOOK_ID_KEY, newFacebookId);
  }



  String get facebookProfileImageUrl{
    return _facebookProfileImageUrl;
  }

  set facebookProfileImageUrl(String newUrl){
    _facebookProfileImageUrl = newUrl;
    savePreferences(FACEBOOK_PROFILE_IMAGE_URL_KEY, newUrl);
  }

  String get fcmToken{
    return _fcmToken;
  }

  set fcmToken(String newToken){
    _fcmToken = newToken;
    savePreferences(FCM_TOKEN_KEY, newToken);
  }

  bool get registered{
    return _registered;
  }

  set registered(bool newRegistered){
    _registered = newRegistered;
    savePreferences(REGISTERED_KEY, newRegistered,sendServer: false);
  }

  bool get ready{
    return _readFromShared;
  }




  void savePreferences(String sharedPreferencesKey, dynamic newValue , {bool sendServer = true}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if(sendServer) {
      _debounce = Timer(_debounceSettingsTime, () async {
        if (canRegister()) {
          await NetworkHelper().postUserSettings();
        }
      });
    }
    if(_registered==true){notifyListeners();}
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(newValue is int) {
      sharedPreferences.setInt(sharedPreferencesKey, newValue);
      return;
    }

    if(newValue is String){
      sharedPreferences.setString(sharedPreferencesKey, newValue);
      return;
    }

    if (newValue is bool){
      sharedPreferences.setBool(sharedPreferencesKey, newValue);
      return;}

    if (newValue is double){
      sharedPreferences.setDouble(sharedPreferencesKey, newValue);
      return;
    }

    return;

  }

}