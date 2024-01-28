
import 'package:hive/hive.dart';

part 'appoinment_model.g.dart';

@HiveType(typeId: 7)
class AppointmentModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String gender;

  @HiveField(3)
  String dob;

  @HiveField(4)
  String email;

  @HiveField(5)
  String mobile;

  @HiveField(6)
  String address;

  @HiveField(7)
  String description;

  @HiveField(8)
  String location;

  @HiveField(9)
  String hospital;

  @HiveField(10)
  String special;

  @HiveField(11)
  String doctor;

  @HiveField(12)
  final DateTime date;

  @HiveField(13)
  final String user;

  @HiveField(14)
  String booktime;

  AppointmentModel(
      {required this.name,
      required this.gender,
      required this.dob,
      required this.email,
      required this.mobile,
      required this.address,
      required this.description,
      required this.date,
      required this.user,
      required this.location,
      required this.hospital,
      required this.special,
      required this.doctor,
      required this.booktime,
      this.id});
}
