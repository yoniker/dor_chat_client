import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
part 'infoUser.g.dart';

@HiveType(typeId : 0)
class InfoUser{
  @HiveField(0)
  String imageUrl;
  @HiveField(1)
  String name;
  @HiveField(2)
  String facebookId;
  InfoUser({required this.imageUrl,required this.name,required this.facebookId});
  InfoUser.fromJson(Map json) :
        this.facebookId = json['facebook_id']??'',
        this.imageUrl = json['facebook_profile_image_url'],
        this.name = json['name'];


  types.User toUiUser(){
    return types.User(id:facebookId,firstName:name,imageUrl: imageUrl);
  }

}