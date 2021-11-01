// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infoMessageReceipt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoMessageReceiptAdapter extends TypeAdapter<InfoMessageReceipt> {
  @override
  final int typeId = 3;

  @override
  InfoMessageReceipt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfoMessageReceipt(
      userId: fields[0] as String,
      sentTime: fields[1] as double,
      readTime: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, InfoMessageReceipt obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.sentTime)
      ..writeByte(2)
      ..write(obj.readTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoMessageReceiptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
