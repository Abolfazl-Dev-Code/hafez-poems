// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ghazal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GhazalAdapter extends TypeAdapter<Ghazal> {
  @override
  final int typeId = 4;

  @override
  Ghazal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ghazal(
      id: fields[0] as String,
      title: fields[1] as String,
      text: fields[2] as String,
      audioUrl: fields[3] as String,
      hasFullText: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Ghazal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.audioUrl)
      ..writeByte(4)
      ..write(obj.hasFullText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GhazalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
