
import 'package:hive_flutter/hive_flutter.dart';
part 'infoMessage.g.dart';

@HiveType(typeId : 1)
class InfoMessage {
  @HiveField(0)
  final String content;
  @HiveField(1)
  final String messageId;
  @HiveField(2)
  final String conversationId;
  @HiveField(3)
  double? addedDate;
  @HiveField(4)
  final double? changedDate;
  @HiveField(5)
  final String userId;
  @HiveField(6)
  final String? messageStatus;
  @HiveField(7)
  final double? sentTime;
  @HiveField(8)
  final double? readTime;

  InfoMessage(
      {required this.content, required this.messageId, required this.conversationId,
        this.addedDate, required this.userId,this.messageStatus,this.changedDate,this.readTime,this.sentTime});
  InfoMessage.fromJson(Map json) :
  content= json['content'], messageId=json['message_id'], conversationId=json['conversation_id'], userId=json['facebook_id'],changedDate=double.parse(json['changed_date']),readTime=double.parse(json['read_date']),messageStatus=json['status'],sentTime=double.parse(json['sent_date']);
}