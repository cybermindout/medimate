// ignore_for_file: unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';

ValueNotifier<List<HospitalModel>> hospitalListNotifier = ValueNotifier([]);

// to add hospitals
Future<void> addHospital(HospitalModel value) async {
  final hospitalBox = await Hive.openBox<HospitalModel>('hospital_db');
  final id = await hospitalBox.add(value);
  final data = hospitalBox.get(id);
  await hospitalBox.put(
    id,
    HospitalModel(
        hos: data!.hos,
        photo: data.photo,
        id: id,
        loc: data.loc,
        specialization: data.specialization),
  );
  getHospitals();
}

// to get hospitals
Future<void> getHospitals() async {
  final hospitalDB = await Hive.openBox<HospitalModel>('hospital_db');
  hospitalListNotifier.value.clear();
  hospitalListNotifier.value.addAll(hospitalDB.values);
  hospitalListNotifier.notifyListeners();
}

// to delete hospitals
Future<void> deleteHospital(int id) async {
  final hospitalDB = await Hive.openBox<HospitalModel>('hospital_db');
  await hospitalDB.delete(id);
  getHospitals();
}

// to search hospitals
Future<List<HospitalModel>> searchHospitals(String keyword) async {
  final hospitalDB = await Hive.openBox<HospitalModel>('hospital_db');
  final hospitals = hospitalDB.values.toList();

  final filteredHospitals = hospitals.where((hospital) {
    return hospital.hos.contains(keyword);
  }).toList();

  return filteredHospitals;
}

// to get hospital count
Future<int> hospitalStats() async {
  final hospitalDB = await Hive.openBox<HospitalModel>('hospital_db');
  final hospitalCount = hospitalDB.length;
  return hospitalCount;
}

Future<void> editHospital(int id, String updatedHospitalName,
    String updatedPhoto, String updatedLoc) async {
  final hospitalBox = await Hive.openBox<HospitalModel>('hospital_db');
  final existingHospital =
      hospitalBox.values.firstWhere((hospital) => hospital.id == id);

  if (existingHospital == null) {
  } else {
    // Update the hospital's name
    existingHospital.hos = updatedHospitalName;
    existingHospital.photo = updatedPhoto;
    existingHospital.loc = updatedLoc;

    // Save the updated hospital back to Hive
    await hospitalBox.put(id, existingHospital);
    getHospitals();
  }
  
}
