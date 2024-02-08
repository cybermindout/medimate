import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String fullname;

  @HiveField(2)
  String dob;

  @HiveField(3)
  String gender;

  @HiveField(4)
  String bloodGroup;

  @HiveField(5)
  String email;

  @HiveField(6)
  String phone;

  @HiveField(7)
  String password;

  UserModel(
      {required this.fullname,
      required this.dob,
      required this.gender,
      required this.bloodGroup,
      required this.email,
      required this.phone,
      required this.password});
}
