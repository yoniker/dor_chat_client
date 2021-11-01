import 'package:hive_flutter/hive_flutter.dart';

part 'infoMessageReceipt.g.dart';

@HiveType(typeId : 3)
class InfoMessageReceipt{
  @HiveField(0)
  String userId;
  @HiveField(1)
  double sentTime;
  @HiveField(2)
  double readTime;

  InfoMessageReceipt({required this.userId,required this.sentTime,required this.readTime});
  static List<InfoMessageReceipt> fromJson(messageJson){
    List<InfoMessageReceipt>InfoMessageReceipts = [];
    List<dynamic> jsonedReceipts = messageJson['receipts']??[];
    for(var jsonedReceipt in jsonedReceipts) {
      InfoMessageReceipts.add(InfoMessageReceipt(userId: jsonedReceipt['user_id'], sentTime: jsonedReceipt['sent_ts']??0, readTime: jsonedReceipt['read_ts']??0));

    }
    return InfoMessageReceipts;}

}
