import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String fullname;

  @HiveField(2)
  final String dob;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final String bloodGroup;

  @HiveField(5)
  final String email;

  @HiveField(6)
  final String phone;

  @HiveField(7)
  final String password;

  UserModel(
      {required this.fullname,
      required this.dob,
      required this.gender,
      required this.bloodGroup,
      required this.email,
      required this.phone,
      required this.password});
}
