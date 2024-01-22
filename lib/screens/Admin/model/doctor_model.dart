import 'package:hive/hive.dart';

part 'doctor_model.g.dart';

@HiveType(typeId: 5)
class DoctorModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String gender;

  @HiveField(3)
  String experience;

  @HiveField(4)
  String dob;

  @HiveField(5)
  List<String> consultingdays;

  @HiveField(6)
  String consultingStartTime;

  @HiveField(7)
  String consultingEndTime;

  @HiveField(8)
  String hospital;

  @HiveField(9)
  String specialization;

  @HiveField(10)
  String photo;



  DoctorModel({
    required this.name,
    required this.gender,
    required this.experience,
    required this.dob,
    required this.consultingdays,
    required this.consultingStartTime,
    required this.consultingEndTime,
    required this.hospital,
    required this.specialization,
    required this.photo, this.id, 
  });
}