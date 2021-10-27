import 'package:dor_chat_client/models/infoMessage.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'infoConversation.g.dart';

@HiveType(typeId : 2)
class InfoConversation{
  @HiveField(0)
  String conversationId;
  @HiveField(1)
  double lastChangedTime;
  @HiveField(2)
  double creationTime;
  @HiveField(3)
  List<String> participantsIds;
  @HiveField(4)
  List<InfoMessage> messages;
  InfoConversation({required this.conversationId,required this.lastChangedTime,required this.creationTime,required this.participantsIds,required this.messages});
  InfoConversation.fromJson(Map json) :
        this.creationTime = json['creation_time']?? 0 ,
        this.lastChangedTime = json['last_changed_time'] ?? 0,
        this.conversationId = json['conversation_id'] ?? '',
        this.messages = [], //TODO think what we want from server's json etc
        this.participantsIds = json['participants']; //TODO further decode that list from json


}