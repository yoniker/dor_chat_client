// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infoConversation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoConversationAdapter extends TypeAdapter<InfoConversation> {
  @override
  final int typeId = 2;

  @override
  InfoConversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfoConversation(
      conversationId: fields[0] as String,
      lastChangedTime: fields[1] as double,
      creationTime: fields[2] as double,
      participants: (fields[3] as List).cast<String>(),
      messages: (fields[4] as List).cast<InfoMessage>(),
    );
  }

  @override
  void write(BinaryWriter writer, InfoConversation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.conversationId)
      ..writeByte(1)
      ..write(obj.lastChangedTime)
      ..writeByte(2)
      ..write(obj.creationTime)
      ..writeByte(3)
      ..write(obj.participants)
      ..writeByte(4)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
