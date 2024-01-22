// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medimate/screens/Admin/admin_screen/doctor/doctor_list.dart';
import 'package:medimate/screens/Admin/db/doctorfunction.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class AddDoctor extends StatefulWidget {
  const AddDoctor({Key? key});

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? selectedGender;
  final List<String> genderOptions = ['Male', 'Female', 'Not Specified'];
  Map<String, bool> consultingDaysMap = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  };
  TimeOfDay? consultingStartTime;
  TimeOfDay? consultingEndTime;
  late Box<SpecialModel> specBox;
  late Box<HospitalModel> hospitalBox;
  List<SpecialModel> specializations = [];
  List<HospitalModel> hospitals = [];
  String? selectedSpecializationName;
  String? selectedHospitalName;

  @override
  void initState() {
    super.initState();
    openHiveBoxes();
  }

  Future<void> openHiveBoxes() async {
    specBox = await Hive.openBox<SpecialModel>('spec_db');
    hospitalBox = await Hive.openBox<HospitalModel>('hospital_db');
    updateLists();
  }

  void updateLists() {
    setState(() {
      specializations = specBox.values.toList();
      hospitals = hospitalBox.values.toList();

      if (!specializations
          .any((spec) => spec.spec == selectedSpecializationName)) {
        selectedSpecializationName = null;
      }

      if (!hospitals.any((hos) => hos.hos == selectedHospitalName)) {
        selectedHospitalName = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "ADD DOCTORS",
            style: appBarTitleStyle(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // add photo
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: const Color.fromARGB(255, 18, 18, 18),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _selectedImage != null
                                  ? Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.fill,
                                    )
                                  : Center(child: Icon(Icons.add_a_photo)),
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _pickImage();
                                },
                                icon: Icon(Icons.photo_library_outlined),
                                tooltip: "select from gallery",
                              ),
                              IconButton(
                                onPressed: () {
                                  _photoImage();
                                },
                                icon: Icon(Icons.camera_alt_outlined),
                                tooltip: "open camera",
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // full name
                      TextFormField(
                        controller: _nameController,
                        validator: validateFullName,
                        decoration: InputDecoration(
                          hintText: "Full Name",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // gender selection
                      DropdownButtonFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "select a gender";
                          }
                          return null;
                        },
                        value: selectedGender,
                        items: genderOptions.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        decoration: InputDecoration(hintText: "Gender"),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // experience
                      TextFormField(
                        controller: _experienceController,
                        validator: validateExperience,
                        decoration: InputDecoration(hintText: 'Experience'),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // consulting days checkboxes
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: consultingDaysMap.keys.map((day) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: consultingDaysMap[day],
                                  onChanged: (value) {
                                    setState(() {
                                      consultingDaysMap[day] = value ?? false;
                                    });
                                  },
                                ),
                                Text(day),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // consulting start time field
                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: consultingStartTime != null
                              ? consultingStartTime!.format(context)
                              : 'Start Time',
                        ),
                        decoration: InputDecoration(
                          hintText: "Consulting Start Time",
                        ),
                        onTap: () {
                          _selectConsultingStartTime(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // consulting end time field
                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: consultingEndTime != null
                              ? consultingEndTime!.format(context)
                              : 'End Time',
                        ),
                        decoration: InputDecoration(
                          hintText: "Consulting End Time",
                        ),
                        onTap: () {
                          _selectConsultingEndTime(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //date of birth
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "select date of birth";
                          }
                          return null;
                        },
                        controller: _dobController,
                        decoration: InputDecoration(hintText: "Date Of Birth"),
                        readOnly: true,
                        onTap: () {
                          _selectDob(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //select hospital
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null) {
                            return "select Hospital";
                          }
                          return null;
                        },
                        value: selectedHospitalName,
                        items: hospitals.map((HospitalModel hospitals) {
                          return DropdownMenuItem<String>(
                            value: hospitals.hos,
                            child: Text(hospitals.hos),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedHospitalName = newValue;
                          });
                        },
                        decoration: InputDecoration(hintText: "Hospital"),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //specialization selection
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null) {
                            return "select Specialization";
                          }
                          return null;
                        },
                        value: selectedSpecializationName,
                        items:
                            specializations.map((SpecialModel specialization) {
                          return DropdownMenuItem<String>(
                            value: specialization.spec,
                            child: Text(specialization.spec),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSpecializationName = newValue;
                          });
                        },
                        decoration: InputDecoration(hintText: "Specialization"),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //submit button
                      ElevatedButton(
                        onPressed: () {
                          submit();
                        },
                        child: Text("ADD DOCTOR"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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

  //to validate experience
  String? validateExperience(String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Qualification is required';
    }
    return null;
  }

  //IMAGE THROUGH CAMERA
  Future<void> _photoImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  //IMAGE FROM PHOTOS
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  //to select dob
  Future<void> _selectDob(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(2023),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  //to select consulting start time
  Future<void> _selectConsultingStartTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        consultingStartTime = pickedTime;
      });
    }
  }

  //to select consulting end time
  Future<void> _selectConsultingEndTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        consultingEndTime = pickedTime;
      });
    }
  }

  Future<void> submit() async {
    final imagepath = _selectedImage!.path;
    final String name = _nameController.text.trim();
    final String gender = selectedGender ?? "";
    final String dob = _dobController.text.trim();
    final String qualification = _experienceController.text.trim();
    final List<String> consultingDays = consultingDaysMap.keys
        .where((day) => consultingDaysMap[day] ?? false)
        .toList();
    final String hospital = selectedHospitalName!;
    final String specialization = selectedSpecializationName!;

    if (_formKey.currentState!.validate()) {
      final doctor = DoctorModel(
        name: name,
        gender: gender,
        experience: qualification,
        dob: dob,
        consultingdays: consultingDays,
        consultingStartTime: consultingStartTime != null
            ? consultingStartTime!.format(context)
            : 'Not Specified',
        consultingEndTime: consultingEndTime != null
            ? consultingEndTime!.format(context)
            : 'Not Specified',
        hospital: hospital,
        specialization: specialization,
        photo: imagepath,
      );
      addDoctor(doctor);
      showSnackBarSuccess(context, "Details added successfully!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DoctorListPage(),
        ),
      );
    } else {
      showSnackBarFailed(context, "Couldn't add details!");
    }
  }

  //code for snackbar success
  void showSnackBarFailed(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  //code for snackbar success
  void showSnackBarSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
