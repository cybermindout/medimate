// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  late Box<HospitalModel> hospitalBox;
  late Box<LocationModel> locBox;
  late Box<DoctorModel> doctorBox;

  List<LocationModel> location = [];
  List<HospitalModel> hospital = [];
  List<DoctorModel> doctor = [];

  String? selectedLocation;
  String? selectedHospital;

  @override
  void initState() {
    super.initState();
    openHiveBoxes();
  }

  Future<void> openHiveBoxes() async {
    locBox = await Hive.openBox<LocationModel>('loc_db');
    hospitalBox = await Hive.openBox<HospitalModel>('hos_db');
    doctorBox = await Hive.openBox<DoctorModel>('doctor_db');
    updateLists();
  }

  void updateLists() {
    setState(() {
      location = locBox.values.toList();
      hospital = hospitalBox.values.toList();
      doctor = doctorBox.values.toList();

      if (!location.any((loc) => loc.loc == selectedLocation)) {
        selectedLocation = null;
      }

      if (!hospital.any((hos) => hos.hos == selectedHospital)) {
        selectedHospital = null;
      }
    });
  }

  List<String> getHospitalsForLocation(String? location) {
    List<String> hospitals = [];
    if (location != null) {
      for (int i = 0; i < hospitalBox.length; i++) {
        HospitalModel hospital = hospitalBox.getAt(i)!;
        if (hospital.loc == location) {
          hospitals.add(hospital.hos);
        }
      }
    }
    return hospitals;
  }

  List<String> getDoctorsForHospital(String? hospital) {
    List<String> doctors = [];
    for (int i = 0; i < doctorBox.length; i++) {
      DoctorModel doctor = doctorBox.getAt(i)!;
      if (doctor.hospital == hospital) {
        doctors.add(doctor.name);
      }
    }
    return doctors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedLocation,
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                  selectedHospital = "";
                });
              },
              items: locBox.values
                  .map<DropdownMenuItem<String>>(
                    (location) => DropdownMenuItem<String>(
                      value: location.loc,
                      child: Text(location.loc),
                    ),
                  )
                  .toList(),
              hint: Text('Select Location'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedHospital,
              onChanged: (value) {
                setState(() {
                  selectedHospital = value;
                });
              },
              items: getHospitalsForLocation(selectedLocation)
                  .map<DropdownMenuItem<String>>(
                    (hospital) => DropdownMenuItem<String>(
                      value: hospital,
                      child: Text(hospital),
                    ),
                  )
                  .toList(),
              hint: Text('Select Hospital'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: null,
              onChanged: null,
              items: selectedHospital!.isNotEmpty
                  ? getDoctorsForHospital(selectedHospital)
                      .map<DropdownMenuItem<String>>(
                        (doctor) => DropdownMenuItem<String>(
                          value: doctor,
                          child: Text(doctor),
                        ),
                      )
                      .toList()
                  : [],
              hint: Text('Select Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
