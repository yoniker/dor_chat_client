
import 'package:dor_chat_client/models/chatData.dart';
import 'package:dor_chat_client/models/infoMessageReceipt.dart';
import 'package:dor_chat_client/models/infoUser.dart';
import 'package:dor_chat_client/models/settings_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
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
  @HiveField(9)
  final Map<String,InfoMessageReceipt> receipts;

  InfoMessage(
      {required this.content, required this.messageId, required this.conversationId,
        this.addedDate, required this.userId,this.messageStatus,this.changedDate,this.readTime,this.sentTime,required this.receipts});
  InfoMessage.fromJson(Map json) :
  content= json['content'],
        messageId=json['message_id'],
        conversationId=json['conversation_id'],
        userId=json['messages_user_id']??json['user_id'], //messages_user_id can happen on message not existing in query of relevant messages so the resulting receipt also has the message info
        changedDate=json['changed_date'] is String? double.parse(json['changed_date']):json['changed_date'], //Had to convert every field on FCM message to string in order to send so sometimes it's a string and sometimes a double..
        readTime=json['read_date'] is String ? double.parse(json['read_date']) : json['read_date'],
        messageStatus=json['status'],
        sentTime=json['sent_date'] is String ? double.parse(json['sent_date']) : json['sent_date'],
        addedDate = json['added_date'] is String?double.parse(json['added_date']):json['added_date'],
        receipts = InfoMessageReceipt.fromJson(json);

  types.TextMessage toUiMessage(){
    InfoUser? author = ChatData().getUserById(userId);
    if(author==null){
      author = InfoUser(imageUrl: '', name: '', facebookId: userId);
    }
    double createdTime = addedDate??changedDate??sentTime??0;
    types.Status status = calculateMessageStatus();
    String? text;
    try{
    Map<String,dynamic> contentsMap = jsonDecode(content);
    text = contentsMap['content'] ?? '';}
    catch (_){
    text='';
    }
    //TODO jsonDecode(content)['type'] will determine how to treat the content value (is it an image url etc)

    return types.TextMessage(author: author.toUiUser(),createdAt: (createdTime*1000).toInt(),id:messageId,status: status,text: text!);
  }

  types.Status calculateMessageStatus() {
    if(userId == SettingsData().facebookId){
      //current user is the one who sent the message
      if(messageStatus=='Uploading'){
        return types.Status.sending;
      }

      if(messageStatus == 'Sent'){
        return types.Status.sent;
      }
      if(messageStatus == 'Error'){
        return types.Status.error;
      }
      //if other users read the message change status to read, otherwise sent
      for(var receiptUserId in receipts.keys){
        if(receiptUserId!=SettingsData().facebookId && receipts[receiptUserId]!.readTime>0){
          return types.Status.seen;
        }

      }
      return types.Status.sent; //TODO change here such that there's an intermediate message not sent to server status
    }

      //Someone else sent the message,so regardless set status to read
    return types.Status.seen;

  }


}