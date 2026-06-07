// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FalModelAdapter extends TypeAdapter<FalModel> {
  @override
  final int typeId = 13;

  @override
  FalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FalModel(
      id: fields[0] as int,
      title: fields[1] as String,
      plainText: fields[2] as String,
      audioUrl: fields[3] as String,
      poemUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FalModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.plainText)
      ..writeByte(3)
      ..write(obj.audioUrl)
      ..writeByte(4)
      ..write(obj.poemUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
