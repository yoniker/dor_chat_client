import 'package:dor_chat_client/services/networking.dart';
import 'package:flutter/material.dart';

class InfoUser{
  String imageUrl;
  String name;
  String facebookId;
  InfoUser({required this.imageUrl,required this.name,required this.facebookId});
  InfoUser.fromJson(Map json) :
        this.facebookId = json['facebook_id']??'',
        this.imageUrl = json['facebook_profile_image_url'],
        this.name = json['name'];

}

class Users extends ChangeNotifier{
  //Make it a singleton
  Users._privateConstructor();
  static final Users _instance = Users._privateConstructor();

  factory Users() {
    return _instance;
  }

  List <InfoUser> _usersAvailableChat = [];

  updateUsers() async{
    List<InfoUser> gottenUsers = await NetworkHelper.getAllUsers();
    _usersAvailableChat = gottenUsers;
    notifyListeners();
  }

  List<InfoUser> get users{
    return _usersAvailableChat;
  }

}