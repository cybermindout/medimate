// ignore_for_file: prefer_const_constructors, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:medimate/screens/Admin/admin_screen/dashboard/dashboard_screen.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';
import 'package:medimate/screens/Guest/guest_screen/splash_screen.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/User/user_screen/home_screen.dart';

const SAVE_KEY_NAME = "UserLoggedIn";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.openBox<UserModel>('user_db');
  Hive.openBox<SpecialModel>('spec_db');
  Hive.openBox<LocationModel>('loc_db');
  Hive.openBox<HospitalModel>('hos_db');
  Hive.openBox<DoctorModel>('doctor_db');

  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
  if (!Hive.isAdapterRegistered(SpecialModelAdapter().typeId)) {
    Hive.registerAdapter(SpecialModelAdapter());
  }
  if (!Hive.isAdapterRegistered(LocationModelAdapter().typeId)) {
    Hive.registerAdapter(LocationModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HospitalModelAdapter().typeId)) {
    Hive.registerAdapter(HospitalModelAdapter());
  }
  if (!Hive.isAdapterRegistered(DoctorModelAdapter().typeId)) {
    Hive.registerAdapter(DoctorModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediMate',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
