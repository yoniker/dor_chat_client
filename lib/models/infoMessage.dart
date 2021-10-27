
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
  double? changedDate;
  @HiveField(5)
  final String userId;
  @HiveField(6)
  final String creatorName;
  @HiveField(7)
  final String? messageStatus;

  InfoMessage(
      {required this.content, required this.messageId, required this.conversationId,
        this.addedDate, required this.userId, required this.creatorName,this.messageStatus});
}