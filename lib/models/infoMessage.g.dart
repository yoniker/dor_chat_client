// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infoMessage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoMessageAdapter extends TypeAdapter<InfoMessage> {
  @override
  final int typeId = 1;

  @override
  InfoMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfoMessage(
      content: fields[0] as String,
      messageId: fields[1] as String,
      conversationId: fields[2] as String,
      addedDate: fields[3] as double?,
      userId: fields[5] as String,
      messageStatus: fields[6] as String?,
      changedDate: fields[4] as double?,
      readTime: fields[8] as double?,
      sentTime: fields[7] as double?,
      receipts: (fields[9] as List).cast<InfoMessageReceipt>(),
    );
  }

  @override
  void write(BinaryWriter writer, InfoMessage obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.messageId)
      ..writeByte(2)
      ..write(obj.conversationId)
      ..writeByte(3)
      ..write(obj.addedDate)
      ..writeByte(4)
      ..write(obj.changedDate)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.messageStatus)
      ..writeByte(7)
      ..write(obj.sentTime)
      ..writeByte(8)
      ..write(obj.readTime)
      ..writeByte(9)
      ..write(obj.receipts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
