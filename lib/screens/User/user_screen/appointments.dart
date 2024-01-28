// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/db/appointment_functions.dart';
import 'package:medimate/screens/Admin/model/appoinment_model.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Admin/model/location_model.dart';
import 'package:medimate/screens/Admin/model/special_model.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/db/filter_function.dart';
import 'package:medimate/screens/User/user_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookAppointment extends StatefulWidget {
  const BookAppointment({Key? key}) : super(key: key);

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
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

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String userEmail = '';
  UserModel? currentUser;

  int age = 0;

  @override
  void initState() {
    super.initState();
    getUser();
    getLocations();
    getHospitals();
    getSpecializations();
    getDoctors();
  }

  Future<void> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('currentUser') ?? '';
    final userBox = await Hive.openBox<UserModel>('user_db');
    currentUser = userBox.values.firstWhere(
      (user) => user.email == userEmail,
    );
    calculateAge();
    setState(() {});
  }

  void calculateAge() {
    if (currentUser != null) {
      String dobString = currentUser!.dob;
      DateTime dob = DateTime.parse(dobString);
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(dob);
      age = (difference.inDays / 365).floor();
    }
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
      filteredDoctors =
          FilterFunctions.filterDoctorsByHospitalAndSpecialization(
              doctorList, selectedHospital!, selectedSpecialization!);
    });
  }

  void onSpecializationChanged(String? newValue) {
    setState(() {
      selectedSpecialization = newValue;
      filteredDoctors =
          FilterFunctions.filterDoctorsByHospitalAndSpecialization(
              doctorList, selectedHospital!, selectedSpecialization!);
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
                          _selectDate(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
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
                          _selectBookDate(context);
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
                          _selectTime(context);
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
                            return "Select a specialization";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        value: selectedSpecialization,
                        onChanged: onSpecializationChanged,
                        items: filteredSpecializations.map((SpecialModel spec) {
                          return DropdownMenuItem<String>(
                            value: spec.spec,
                            child: Text(spec.spec),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.medical_services,
                            color: Colors.grey,
                          ),
                          hintText: "Select Specialization",
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
                            child: Text(doctor.name),
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

  Future<void> _selectDate(BuildContext context) async {
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

  Future<void> _selectBookDate(BuildContext context) async {
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

  Future<void> _selectTime(BuildContext context) async {
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
