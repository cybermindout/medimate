// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/db/appointment_functions.dart';
import 'package:medimate/screens/Admin/model/appoinment_model.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/db/appointment_functions.dart';
import 'package:medimate/screens/User/user_screen/home_screen.dart';
import 'package:medimate/screens/User/db/filter_function.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({Key? key}) : super(key: key);

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
    getLocations();
    getHospitals();
    getSpecializations();
    getDoctors();
  }

  void onLocationChanged(String? newValue) {
    setState(() {
      selectedLocation = newValue;
      filteredHospitals = FilterFunctions()
          .filterHospitalsByLocation(hospitalList, selectedLocation!);
    });
  }

  void onHospitalChanged(String? newValue) {
    setState(() {
      selectedHospital = newValue;
      filteredDoctors = FilterFunctions()
          .filterDoctorsByHospital(doctorList, selectedHospital!);
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
            "BOOK APPOINTMENTS",
            style: appBarTitleStyle(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select a title";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.title),
                        ),
                        hint: Text("Title"),
                        value: selectedDescription,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDescription = newValue;
                          });
                        },
                        items: description.map((String title) {
                          return DropdownMenuItem<String>(
                            value: title,
                            child: Text(title),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _nameController,
                        validator: validateFullName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.abc),
                          hintText: "Full Name",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select a gender";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        value: selectedGender,
                        items: genderOptions.map((String gender) {
                          return DropdownMenuItem<String>(
                              value: gender, child: Text(gender));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.arrow_right_rounded,
                              color: Colors.grey,
                            ),
                            hintText: "Gender"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select date of birth";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _dobController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
                            hintText: "Date Of Birth"),
                        readOnly: true,
                        onTap: () {
                          selectDate(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: validateEmail,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            hintText: "Email"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: validateNumber,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        controller: _mobileController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.call,
                              color: Colors.grey,
                            ),
                            hintText: "Mobile"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _addressController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validateEmpty,
                        decoration: InputDecoration(
                          hintText: "Address",
                          prefixIcon: Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select a date";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _dateController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                          hintText: "Booking Date",
                        ),
                        onTap: () {
                          selectBookDate(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select a time";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _timeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: Colors.grey,
                          ),
                          hintText: "Time",
                        ),
                        readOnly: true,
                        onTap: () {
                          selectTime(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select a location";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        value: selectedLocation,
                        onChanged: onLocationChanged,
                        items: locationList.map((LocationModel location) {
                          return DropdownMenuItem<String>(
                            value: location.loc,
                            child: Text(location.loc),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          hintText: "Select Location",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select a hospital";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        value: selectedHospital,
                        onChanged: onHospitalChanged,
                        items: filteredHospitals.map((HospitalModel hospital) {
                          return DropdownMenuItem<String>(
                            value: hospital.hos,
                            child: Text(hospital.hos),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.local_hospital,
                            color: Colors.grey,
                          ),
                          hintText: "Select Hospital",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select a doctor";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        value: selectedDoctor,
                        items: filteredDoctors.map((DoctorModel doctor) {
                          return DropdownMenuItem<String>(
                            value: doctor.name,
                            child: Text(
                                "${doctor.name} (${doctor.specialization})"),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDoctor = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                          hintText: "Select Doctor",
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addAppointmentButton();
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getSpecializations() async {
    final specialBox = await Hive.openBox<SpecialModel>('spec_db');
    setState(() {
      specializationList = specialBox.values.toList();
    });
  }

  Future<void> getDoctors() async {
    final doctorBox = await Hive.openBox<DoctorModel>('doctor_db');
    setState(() {
      doctorList = doctorBox.values.toList();
    });
  }

  Future<void> getLocations() async {
    final locationBox = await Hive.openBox<LocationModel>('loc_db');
    setState(() {
      locationList = locationBox.values.toList();
    });
  }

  Future<void> getHospitals() async {
    final hospitalBox = await Hive.openBox<HospitalModel>('hospital_db');
    setState(() {
      hospitalList = hospitalBox.values.toList();
    });
  }

  Future<void> addAppointmentButton() async {
    final String description = selectedDescription ?? "";
    final String name = _nameController.text.trim();
    final String gender = selectedGender ?? "";
    final String dob = _dobController.text.trim();
    final String email = _emailController.text.trim();
    final String mobile = _mobileController.text.trim();
    final String address = _addressController.text.trim();
    final DateTime date = DateTime.now();
    final String user = currentUser!.fullname;

    if (_formKey.currentState!.validate()) {
      //print("validated");
      final appointment = AppointmentModel(
          name: name,
          gender: gender,
          dob: dob,
          email: email,
          mobile: mobile,
          address: address,
          date: date,
          user: user,
          description: '',
          location: '',
          hospital: '',
          special: '',
          doctor: '',
          booktime: '');
      addAppointment(appointment);
      showSnackBarSuccess(context, 'We will contact you soon');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } else {
      setState(() {
        //showError = true;
      });

      showSnackBarFailed(context, "Enquiry couldn't be placed. Try again ");
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now(); // Initialize with the current date.

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900), // Start date for selection
      lastDate: DateTime(2025), // End date for selection
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> selectBookDate(BuildContext context) async {
    DateTime selectedBookDate =
        DateTime.now(); // Initialize with the current date.

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2024),
      firstDate: DateTime(1900), // Start date for selection
      lastDate: DateTime(2025), // End date for selection
    );

    if (picked != null && picked != selectedBookDate) {
      setState(() {
        selectedBookDate = picked;
        _dateController.text =
            selectedBookDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay selectedTime =
        TimeOfDay.now(); // Initialize with the current time.

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = selectedTime.format(context);
      });
    }
  }
}
