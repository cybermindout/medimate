import 'package:hive/hive.dart';
part 'hospital_model.g.dart';

@HiveType(typeId: 4)
class HospitalModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String hos;

  @HiveField(2)
  String photo;

  @HiveField(3)
  String loc;

  @HiveField(4)
  String specialization;

  HospitalModel(
      {required this.hos,
      required this.photo,
      this.id,
      required this.loc,
      required this.specialization
     });
}
