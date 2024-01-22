// ignore_for_file: no_leading_underscores_for_local_identifiers, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';

ValueNotifier<List<UserModel>> userListNotifier = ValueNotifier([]);

//to add users
Future<void> addUser(UserModel value) async {
  final userDB = await Hive.openBox<UserModel>('user_db');
  final _id = await userDB.add(value);
  value.id = _id;
  userListNotifier.value.add(value);
  userListNotifier.notifyListeners();
}

Future<int> userStats() async{
  final userDB = await Hive.openBox<UserModel>('user_db');
  final userCount=userDB.length;
  return userCount;
}