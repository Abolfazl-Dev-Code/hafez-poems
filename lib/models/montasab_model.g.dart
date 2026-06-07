// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'montasab_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MontasabModelAdapter extends TypeAdapter<MontasabModel> {
  @override
  final int typeId = 15;

  @override
  MontasabModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MontasabModel(
      id: fields[0] as String,
      title: fields[1] as String,
      text: fields[2] as String,
      audioUrl: fields[3] as String,
      hasFullText: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MontasabModel obj) {
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
      other is MontasabModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
