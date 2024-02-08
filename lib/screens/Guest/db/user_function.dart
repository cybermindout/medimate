// ignore_for_file: no_leading_underscores_for_local_identifiers, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/User/db/userappointment_functions.dart';

ValueNotifier<List<UserModel>> userListNotifier = ValueNotifier([]);

//to add users
Future<void> addUser(UserModel value) async {
  final userDB = await Hive.openBox<UserModel>('user_db');
  final _id = await userDB.add(value);
  value.id = _id;
  userListNotifier.value.add(value);
  userListNotifier.notifyListeners();
}

Future<int> userStats() async {
  final userDB = await Hive.openBox<UserModel>('user_db');
  final userCount = userDB.length;
  return userCount;
}

Future<void> editUser(
    int id,
    String updatedUserName,
    String updatedEmail,
    String updatedGender,
    String updatedDob,
    String updatedBloodGroup,
    String updatedPhone) async {
  final userBox = await Hive.openBox<UserModel>('user_db');
  final existingUser = userBox.values.firstWhere((user) => user.id == id);

  if (existingUser == null) {
  } else {
    existingUser.fullname = updatedUserName;
    existingUser.email = updatedEmail;
    existingUser.gender = updatedGender;
    existingUser.dob = updatedDob;
    existingUser.bloodGroup = updatedBloodGroup;
    existingUser.phone = updatedPhone;
    await userBox.put(id, existingUser);
    getUser();
  }
}
