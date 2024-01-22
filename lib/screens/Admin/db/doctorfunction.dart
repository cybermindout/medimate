// ignore_for_file: unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';

ValueNotifier<List<DoctorModel>> doctorListNotifier = ValueNotifier([]);

//to add doctors
Future<void> addDoctor(DoctorModel value) async {
  final doctorDB = await Hive.openBox<DoctorModel>('doctor_db');
  final id = await doctorDB.add(value);
  final data = doctorDB.get(id);
  await doctorDB.put(
      id,
      DoctorModel(
        name: data!.name,
        gender: data.gender,
        dob: data.dob,
        experience: data.experience,
        consultingStartTime: data.consultingStartTime,
        consultingEndTime: data.consultingEndTime,
        consultingdays: data.consultingdays,
        hospital: data.hospital,
        specialization: data.specialization,
        photo: data.photo,
        id: id,
      ));
  //print(doctorDB.values);
}

//to get doctors
Future<void> getDoctor() async {
  final doctorDB = await Hive.openBox<DoctorModel>('doctor_db');
  doctorListNotifier.value.clear();
  doctorListNotifier.value.addAll(doctorDB.values);
  doctorListNotifier.value.sort((a, b) => a.name.compareTo(b.name));

  doctorListNotifier.notifyListeners();
}

//to delete doctors
Future<void> deleteDoctor(int id) async {
  final docDB = await Hive.openBox<DoctorModel>('doctor_db');
  await docDB.delete(id);
  getDoctor();
}

//to get doctor count
Future<int> doctorStats() async {
  final docDB = await Hive.openBox<DoctorModel>('doctor_db');
  final docCount = docDB.length;
  return docCount;
}

Future<void> editDoctor(
    int id,
    String updatedPhoto,
    String updatedName,
    String updatedGender,
    String updatedDOB,
    String updatedExperience,
    updatedConsultingstarttime,
    updatedConsultingendtime,
    List<String> updatedConsultingdays,
    String updatedHospital,
    String updatedSpec) async {
  final specBox = await Hive.openBox<DoctorModel>('doctor_db');
  final existingDoctor = specBox.values.firstWhere((doc) => doc.id == id);

  if (existingDoctor == null) {
  } else {
    // Update
    existingDoctor.photo = updatedPhoto;
    existingDoctor.name = updatedName;
    existingDoctor.gender = updatedGender;
    existingDoctor.experience = updatedExperience;
    existingDoctor.consultingStartTime = updatedConsultingstarttime;
    existingDoctor.consultingEndTime = updatedConsultingendtime;
    existingDoctor.consultingdays = updatedConsultingdays;
    existingDoctor.hospital = updatedHospital;
    existingDoctor.dob = updatedDOB;
    existingDoctor.specialization = updatedSpec;

    // Save the updated
    await specBox.put(id, existingDoctor);
    getDoctor();
  }
}
