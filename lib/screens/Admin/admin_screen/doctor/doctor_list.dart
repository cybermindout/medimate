// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medimate/screens/Admin/db/doctorfunction.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _consultingdaysController =
      TextEditingController();
  final TextEditingController _consultingstarttimeController =
      TextEditingController();
  final TextEditingController _consultingendtimeController =
      TextEditingController();
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
  List<SpecialModel> specialization = [];
  List<HospitalModel> hospitals = [];
  String? selectedSpecializationsName;
  String? selectedHospitalName;

  @override
  void initState() {
    super.initState();
    openHiveBoxes();
    getDoctor();
  }

  Future<void> openHiveBoxes() async {
    specBox = await Hive.openBox<SpecialModel>('spec_db');
    hospitalBox = await Hive.openBox<HospitalModel>('hos_db');
    updateLists();
  }

  void updateLists() {
    setState(() {
      specialization = specBox.values.toList();
      hospitals = hospitalBox.values.toList();

      if (!specialization
          .any((spec) => spec.spec == selectedSpecializationsName)) {
        selectedSpecializationsName =
            specialization.isNotEmpty ? specialization[0].spec : null;
      }

      if (!hospitals.any((hos) => hos.hos == selectedHospitalName)) {
        selectedHospitalName = hospitals.isNotEmpty ? hospitals[0].hos : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "DOCTORS LIST",
              style: appBarTitleStyle(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 690,
                    child: ValueListenableBuilder(
                      valueListenable: doctorListNotifier,
                      builder: (BuildContext ctx, List<DoctorModel> doctorList,
                          Widget? child) {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            final data = doctorList[index];
                            return Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 98, 249, 184),
                                  borderRadius: BorderRadius.circular(30)),
                              child: ListTile(
                                onTap: () {},
                                contentPadding: EdgeInsets.all(5),
                                leading: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: FileImage(File(data.photo)),
                                ),
                                title: Text(
                                  "Dr.${data.name}",
                                  style: doctorListTitle(),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Specialization: ${data.specialization}",
                                      style: doctorListSubtitle(),
                                    ),
                                    Text(
                                      "Experience: ${data.experience}",
                                      style: doctorListSubtitle(),
                                    ),
                                    Text(
                                      "Hospital: ${data.hospital}",
                                      style: doctorListSubtitle(),
                                    ),
                                    Text(
                                      "Consulting days: ${data.consultingdays}",
                                      style: doctorListSubtitle(),
                                    ),
                                    Text(
                                      "Consulting Start time: ${data.consultingStartTime}",
                                      style: doctorListSubtitle(),
                                    ),
                                    Text(
                                      "Consulting end time: ${data.consultingEndTime}",
                                      style: doctorListSubtitle(),
                                    ),
                                    Text(
                                      "Dob: ${data.dob}",
                                      style: doctorListSubtitle(),
                                    ),
                                    Text(
                                      "Gender: ${data.gender}",
                                      style: doctorListSubtitle(),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        deleteDoctor(data.id!);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(255, 248, 3, 3),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _editSheet(
                                          context,
                                          data.id!,
                                          data.photo,
                                          data.name,
                                          data.gender,
                                          data.experience,
                                          data.consultingStartTime
                                              as TimeOfDay?,
                                          data.consultingEndTime as TimeOfDay?,
                                          data.consultingdays,
                                          data.hospital,
                                          data.dob,
                                          data.specialization,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 3, 56, 248),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: doctorList.length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editSheet(
    BuildContext context,
    int id,
    String photo,
    String name,
    String gender,
    String experience,
    TimeOfDay? consultingStartTime,
    TimeOfDay? consultingEndTime,
    List<String> consultingdays,
    String hosp,
    String dob,
    String spec,
  ) {
    _selectedImage = File(photo);
    _nameController.text = name;
    selectedGender = gender;
    _experienceController.text = experience;
    _consultingdaysController.text = consultingdays.join(', ');
    _consultingstarttimeController.text = consultingStartTime as String;
    _consultingendtimeController.text = consultingEndTime as String;
    selectedHospitalName = hosp;
    if (specialization.any((s) => s.spec == spec)) {
      selectedSpecializationsName = spec;
    } else {
      selectedSpecializationsName =
          specialization.isNotEmpty ? specialization[0].spec : null;
    }

    _dobController.text = dob;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                      DropdownButtonFormField<String>(
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
                      TextFormField(
                        controller: _experienceController,
                        validator: validateExperience,
                        decoration: InputDecoration(
                          hintText: "Qualification",
                        ),
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
                              ? consultingStartTime.format(context)
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
                              ? consultingEndTime.format(context)
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
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "select date of birth";
                          }
                          return null;
                        },
                        controller: _dobController,
                        decoration: InputDecoration(
                          hintText: "Date Of Birth",
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDob(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        borderRadius: BorderRadius.circular(70),
                        validator: (value) {
                          if (value == null) {
                            return "select Hospital";
                          }
                          return null;
                        },
                        value: selectedHospitalName,
                        items: hospitals.map((HospitalModel hospital) {
                          return DropdownMenuItem<String>(
                            value: hospital.hos,
                            child: Text(hospital.hos),
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
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null) {
                            return "select Specialization";
                          }
                          return null;
                        },
                        value: selectedSpecializationsName,
                        items:
                            specialization.map((SpecialModel specialization) {
                          return DropdownMenuItem<String>(
                            value: specialization.spec,
                            child: Text(specialization.spec),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSpecializationsName = newValue;
                          });
                        },
                        decoration: InputDecoration(hintText: "Specialization"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          editDoctor(
                            id,
                            _selectedImage!.path,
                            _nameController.text,
                            selectedGender!,
                            _experienceController.text,
                            _consultingstarttimeController.text,
                            _consultingendtimeController.text,
                            _consultingdaysController.text.split(', ')
                                as String,
                            selectedHospitalName as List<String>,
                            _dobController.text,
                            selectedSpecializationsName as String,
                          );
                          showSnackBarSuccess(
                              context, "Details updated successfully!");
                          Navigator.pop(context);
                        },
                        child: Text("Update"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSnackBarSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _photoImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

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

  String? validateExperience(String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Experience is required';
    }
    return null;
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
}