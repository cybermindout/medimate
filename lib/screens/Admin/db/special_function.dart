// ignore_for_file: unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';

ValueNotifier<List<SpecialModel>> specListNotifier = ValueNotifier([]);

//to add specials
Future<void> addspecial(SpecialModel value) async {
  final specBox = await Hive.openBox<SpecialModel>('spec_db');
  final id = await specBox.add(value);
  final data = specBox.get(id);
  await specBox.put(
      id, SpecialModel(spec: data!.spec, photo: data.photo, id: id));
  getspecial();
}

//to get specials
Future<void> getspecial() async {
  final specDB = await Hive.openBox<SpecialModel>('spec_db');
  specListNotifier.value.clear();
  specListNotifier.value.addAll(specDB.values);
  specListNotifier.notifyListeners();
}

//to delete specials
Future<void> deletespec(int id) async {
  final specDB = await Hive.openBox<SpecialModel>('spec_db');
  await specDB.delete(id);
  getspecial();
}

//to search specials
Future<List<SpecialModel>> searchspecials(String keyword) async {
  final specDB = await Hive.openBox<SpecialModel>('spec_db');
  final specials = specDB.values.toList();

  final filteredspecials = specials.where((special) {
    return special.spec.contains(keyword);
  }).toList();

  return filteredspecials;
}

//to get special count
Future<int> specialStats() async {
  final specDB = await Hive.openBox<SpecialModel>('spec_db');
  final specialCount = specDB.length;
  return specialCount;
}

Future<void> editspecial(
    int id, String updatedspecialName, String updatedPhoto) async {
  final specBox = await Hive.openBox<SpecialModel>('spec_db');
  final existingSpecial = specBox.values.firstWhere((spec) => spec.id == id);

  if (existingSpecial == null){
  } else {
    existingSpecial.spec = updatedspecialName;
    existingSpecial.photo = updatedPhoto;

    await specBox.put(id, existingSpecial);
    getspecial();
  }

  
}
