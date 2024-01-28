// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appoinment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentModelAdapter extends TypeAdapter<AppointmentModel> {
  @override
  final int typeId = 7;

  @override
  AppointmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentModel(
      name: fields[1] as String,
      gender: fields[2] as String,
      dob: fields[3] as String,
      email: fields[4] as String,
      mobile: fields[5] as String,
      address: fields[6] as String,
      description: fields[7] as String,
      date: fields[12] as DateTime,
      user: fields[13] as String,
      location: fields[8] as String,
      hospital: fields[9] as String,
      special: fields[10] as String,
      doctor: fields[11] as String,
      booktime: fields[14] as String,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.dob)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.mobile)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.hospital)
      ..writeByte(10)
      ..write(obj.special)
      ..writeByte(11)
      ..write(obj.doctor)
      ..writeByte(12)
      ..write(obj.date)
      ..writeByte(13)
      ..write(obj.user)
      ..writeByte(14)
      ..write(obj.booktime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
