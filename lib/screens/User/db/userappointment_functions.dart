// ignore_for_file: unused_element, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';

import 'package:medimate/screens/User/user_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _formKey = GlobalKey<FormState>();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _dobController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _mobileController = TextEditingController();
final TextEditingController _addressController = TextEditingController();
final TextEditingController _dateController = TextEditingController();
final TextEditingController _timeController = TextEditingController();

String? selectedDescription;
final List<String> description = ['Mr.', 'Mrs.', 'Ms', 'Baby', 'Baby Of'];
String? selectedGender;
final List<String> genderOptions = ['Male', 'Female', 'Others'];

String? selectedLocation;
List<LocationModel> locationList = [];

String? selectedHospital;
List<HospitalModel> hospitalList = [];

String? selectedSpecialization;
List<SpecialModel> specializationList = [];

String? selectedDoctor;
List<DoctorModel> doctorList = [];

List<HospitalModel> filteredHospitals = [];
List<SpecialModel> filteredSpecializations = [];
List<DoctorModel> filteredDoctors = [];

String userEmail = '';
UserModel? currentUser;

int age = 0;

Future<void> getUser() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  userEmail = prefs.getString('currentUser') ?? '';
  final userBox = await Hive.openBox<UserModel>('user_db');
  currentUser = userBox.values.firstWhere(
    (user) => user.email == userEmail,
  );
}

//to validate full name
String? validateFullName(String? value) {
  final trimmedValue = value?.trim();

  if (trimmedValue == null || trimmedValue.isEmpty) {
    return 'Full Name is required';
  }

  final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');

  if (!nameRegExp.hasMatch(trimmedValue)) {
    return 'Full Name can only contain letters and spaces';
  }

  return null;
}

//to validate email
String? validateEmail(String? value) {
  final trimmedValue = value?.trim();

  if (trimmedValue == null || trimmedValue.isEmpty) {
    return 'Email is required';
  }

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  if (!emailRegExp.hasMatch(trimmedValue)) {
    return 'Invalid email address';
  }

  return null;
}

//to validate number
String? validateNumber(String? value) {
  final trimmedValue = value?.trim();

  if (trimmedValue == null || trimmedValue.isEmpty) {
    return 'Mobile number is required';
  }

  final RegExp numberRegExp = RegExp(r'^[0-9]{10}$');

  if (!numberRegExp.hasMatch(trimmedValue)) {
    return 'Mobile number must be exactly 10 digits and contain only numbers';
  }

  return null;
}

//to validate cannot be empty
String? validateEmpty(String? value) {
  final trimmedValue = value?.trim();

  if (trimmedValue == null || trimmedValue.isEmpty) {
    return 'Cannot be empty';
  }
  return null;
}

//submit form

//code for success snackbar
void showSnackBarSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(message),
      duration: Duration(seconds: 3),
    ),
  );
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      (route) => false);
}

//code for failed snackbar
void showSnackBarFailed(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red[400],
      content: Text(message),
      duration: Duration(seconds: 3),
    ),
  );
}
