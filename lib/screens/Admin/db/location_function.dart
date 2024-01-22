// ignore_for_file: unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';

ValueNotifier<List<LocationModel>> locListNotifier = ValueNotifier([]);

//to add locations
Future<void> addLocation(LocationModel value) async {
  final locBox = await Hive.openBox<LocationModel>('loc_db');
  final id = await locBox.add(value);
  final data = locBox.get(id);
  await locBox.put(id, LocationModel(loc: data!.loc, id: id));
  getLocations();
}

//to get locationsw
Future<void> getLocations() async {
  final locDB = await Hive.openBox<LocationModel>('loc_db');
  locListNotifier.value.clear();
  locListNotifier.value.addAll(locDB.values);
  locListNotifier.notifyListeners();
}

//to delete locations
Future<void> deleteLocation(int id) async {
  final locDB = await Hive.openBox<LocationModel>('loc_db');
  await locDB.delete(id);
  getLocations();
}

//to search locations
Future<List<LocationModel>> searchLocations(String keyword) async {
  final locDB = await Hive.openBox<LocationModel>('loc_db');
  final locations = locDB.values.toList();

  // Use the `where` method to filter the data based on the search criteria
  final filteredLocations = locations.where((location) {
    // Modify the condition based on your search criteria
    return location.loc.contains(keyword);
  }).toList();

  return filteredLocations;
}

//to get location count
Future<int> locationStats() async {
  final locDB = await Hive.openBox<LocationModel>('loc_db');
  final locationCount = locDB.length;
  return locationCount;
}

Future<void> editLocation(
    int id, String updatedLocationName, String updatedPhoto) async {
  final locBox = await Hive.openBox<LocationModel>('loc_db');
  final existingLocation = locBox.values.firstWhere((loc) => loc.id == id);

  if (existingLocation == null) {
  } else {
    existingLocation.loc = updatedLocationName;
    await locBox.put(id, existingLocation);
    getLocations();
  }
}
