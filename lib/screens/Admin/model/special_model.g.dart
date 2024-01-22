// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpecialModelAdapter extends TypeAdapter<SpecialModel> {
  @override
  final int typeId = 2;

  @override
  SpecialModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpecialModel(
      spec: fields[1] as String,
      photo: fields[2] as String,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SpecialModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.spec)
      ..writeByte(2)
      ..write(obj.photo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
