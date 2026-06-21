// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_poem_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OtherPoemModelAdapter extends TypeAdapter<OtherPoemModel> {
  @override
  final int typeId = 16;

  @override
  OtherPoemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OtherPoemModel(
      id: fields[0] as String,
      title: fields[1] as String,
      kind: fields[5] as String,
      text: fields[2] as String,
      audioUrl: fields[3] as String,
      hasFullText: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OtherPoemModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.audioUrl)
      ..writeByte(4)
      ..write(obj.hasFullText)
      ..writeByte(5)
      ..write(obj.kind);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtherPoemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
