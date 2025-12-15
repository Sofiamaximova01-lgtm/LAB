// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversion_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversionHistoryAdapter extends TypeAdapter<ConversionHistory> {
  @override
  final int typeId = 2;

  @override
  ConversionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversionHistory(
      type: ConversionType.values[fields[0] as int],
      inputValue: fields[1] as double,
      resultValue: fields[2] as double,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ConversionHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type.index)
      ..writeByte(1)
      ..write(obj.inputValue)
      ..writeByte(2)
      ..write(obj.resultValue)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConversionTypeAdapter extends TypeAdapter<ConversionType> {
  @override
  final int typeId = 1;

  @override
  ConversionType read(BinaryReader reader) {
    return ConversionType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, ConversionType obj) {
    writer.writeByte(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}