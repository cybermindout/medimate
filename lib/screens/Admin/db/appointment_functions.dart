// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/model/appoinment_model.dart';

ValueNotifier<List<AppointmentModel>> appointmentListNotifier =
    ValueNotifier([]);
ValueNotifier<List<AppointmentModel>> userAppointmentListNotifier =
    ValueNotifier([]);

//to add appointment
Future<void> addAppointment(AppointmentModel value) async {
  final appointmentDB = await Hive.openBox<AppointmentModel>('appointment_db');
  final id = await appointmentDB.add(value);
  final data = appointmentDB.get(id);
  await appointmentDB.put(
      id,
      AppointmentModel(
          name: data!.name,
          gender: data.gender,
          dob: data.dob,
          description: data.description,
          email: data.email,
          mobile: data.mobile,
          address: data.address,
          date: data.date,
          user: data.user,
          id: id,
          location: data.location,
          hospital: data.hospital,
          special: data.special,
          doctor: data.doctor,
          booktime: data.booktime));
  getAppointment();
}

//to get appointments
Future<void> getAppointment() async {
  final appointmentDB = await Hive.openBox<AppointmentModel>('appointment_db');
  appointmentListNotifier.value.clear();
  appointmentListNotifier.value.addAll(appointmentDB.values);
  appointmentListNotifier.notifyListeners();
}

//to get appointment count
Future<int> appointmentStats() async {
  final appointmentDB = await Hive.openBox<AppointmentModel>('appointment_db');
  final appointmentCount = appointmentDB.length;
  return appointmentCount;
}

//to get appointment of specific user
Future<void> getUserAppointment(String userName) async {
  final appointmentDB = await Hive.openBox<AppointmentModel>('appointment_db');
  userAppointmentListNotifier.value.clear();

  // Filter appointments based on the userId
  final userAppointments = appointmentDB.values
      .where((appointment) => appointment.user == userName)
      .toList();

  userAppointmentListNotifier.value.addAll(userAppointments);
  userAppointmentListNotifier.notifyListeners();
}
