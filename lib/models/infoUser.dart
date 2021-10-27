import 'package:hive_flutter/hive_flutter.dart';
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

}