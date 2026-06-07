// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liked_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LikedItemAdapter extends TypeAdapter<LikedItem> {
  @override
  final int typeId = 0;

  @override
  LikedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikedItem(
      id: fields[0] as String,
      title: fields[1] as String,
      text: fields[2] as String,
      audioUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LikedItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.audioUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
