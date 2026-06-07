// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlight_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HighlightItemAdapter extends TypeAdapter<HighlightItem> {
  @override
  final int typeId = 2;

  @override
  HighlightItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HighlightItem(
      ghazalId: fields[0] as String,
      ghazalTitle: fields[1] as String,
      ghazalText: fields[2] as String,
      audioUrl: fields[3] as String,
      highlightedLine: fields[4] as String,
      lineIndex: fields[5] as int,
      colorValue: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HighlightItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.ghazalId)
      ..writeByte(1)
      ..write(obj.ghazalTitle)
      ..writeByte(2)
      ..write(obj.ghazalText)
      ..writeByte(3)
      ..write(obj.audioUrl)
      ..writeByte(4)
      ..write(obj.highlightedLine)
      ..writeByte(5)
      ..write(obj.lineIndex)
      ..writeByte(6)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighlightItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
