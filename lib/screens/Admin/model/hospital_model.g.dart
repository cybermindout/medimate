// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HospitalModelAdapter extends TypeAdapter<HospitalModel> {
  @override
  final int typeId = 4;

  @override
  HospitalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HospitalModel(
      hos: fields[1] as String,
      photo: fields[2] as String,
      id: fields[0] as int?,
      loc: fields[3] as String,
      specialization: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HospitalModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.hos)
      ..writeByte(2)
      ..write(obj.photo)
      ..writeByte(3)
      ..write(obj.loc)
      ..writeByte(4)
      ..write(obj.specialization);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HospitalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
