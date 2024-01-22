// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Guest/db/user_function.dart';
import 'package:medimate/screens/Guest/guest_screen/login_screen.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/User/user_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medimate/main.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? selectedGender;
  final List<String> genderOptions = ['Male', 'Female', 'Not to specify'];
  String? selectedBloodGroup;
  final List<String> bloodGroup = ['A+', 'B+', 'O+', 'AB+', 'o-'];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(149, 207, 255, 1),
              Colors.white,
              Color.fromARGB(255, 216, 255, 217),
            ],
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Center(
                        child: Align(
                      alignment: Alignment.center,
                      child: Text('Join Us',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: -0.30,
                          )),
                    )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'You can search Doctors, and make \n appointments',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF677294),
                      fontSize: 14,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: -0.30,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: validateFullName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "Full Name",
                    ),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _dobController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Date Of Birth"),
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  //gender selection
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "select a gender";
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Gender"),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "select a blood group";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    value: selectedBloodGroup,
                    items: bloodGroup.map((String bloodgroup) {
                      return DropdownMenuItem<String>(
                          value: bloodgroup, child: Text(bloodgroup));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBloodGroup = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Blood Group"),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  //email
                  TextFormField(
                    validator: validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Email"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //phone
                  TextFormField(
                    validator: validatePhone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Phone"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //password
                  TextFormField(
                    validator: validatePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Password"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //confirm password
                  TextFormField(
                    validator: validatecpassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    controller: _cpasswordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Confirm Password"),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  //login button
                  SizedBox(
                    width: 295,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        userCheck(_emailController.text);
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Rubik'),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFF0EBE7F))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx1) => LoginScreen(),
                      ));
                    },
                    child: Text(
                      '''Have an account? Log in''',
                      style: TextStyle(
                        color: Color(0xFF0EBE7F),
                        fontSize: 14,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: -0.30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1999),
      firstDate: DateTime(1900),
      lastDate: DateTime(2023),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
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

//to validate phone number
  String? validatePhone(String? value) {
    final trimmedValue = value?.trim();
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return '{Phone is required';
    }
    final RegExp phoneRegExp = RegExp(
      r'(^(?:[+0]9)?[0-9]{10,12}$)',
    );

    if (!phoneRegExp.hasMatch(trimmedValue)) {
      return 'Invalid phone number';
    }

    return null;
  }

//to validate password
  String? validatePassword(String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

//to validate confirm password
  String? validatecpassword(String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Cannot be empty';
    }
    if (trimmedValue != _passwordController.text) {
      return 'Password must watch';
    }
    return null;
  }

//to check if new user
  void userCheck(String email) async {
    await Hive.openBox<UserModel>('user_db');
    final userDB = Hive.box<UserModel>('user_db');
    final userExists = userDB.values.any((user) => user.email == email);

    if (userExists) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("User already exists"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"))
              ],
            );
          });
    } else {
      addUserbutton();
    }
  }

//to add user
  Future<void> addUserbutton() async {
    final String fullName = _nameController.text.trim();
    final String dateOfBirth = _dobController.text.trim();
    final String gender = selectedGender ?? "";
    final String bloodGroup = selectedBloodGroup ?? "";
    final String email = _emailController.text.trim();
    final String phone = _phoneController.text.trim();
    final String pass = _passwordController.text.trim();

    if (_formKey.currentState!.validate() &&
        _passwordController.text == _cpasswordController.text) {
      final _user = UserModel(
          fullname: fullName,
          dob: dateOfBirth,
          gender: gender,
          bloodGroup: bloodGroup,
          email: email,
          phone: phone,
          password: pass);
      addUser(_user);
      //Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => LoginPage(),));
      login(_emailController.text, _passwordController.text, context);
    } else {
      showSnackBar(context, 'User registration failed!');
    }
  }

//code for snackbar
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

//to login
  void login(String email, String password, BuildContext context) async {
    final userDB = await Hive.openBox<UserModel>('user_db');

    UserModel? user;
    for (var i = 0; i < userDB.length; i++) {
      final currentUser = userDB.getAt(i);

      if (currentUser?.email == email && currentUser?.password == password) {
        user = currentUser;
        break;
      }
    }

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(SAVE_KEY_NAME, true);
      await saveUserEmail(email);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // title : const Text("error"),
              content: const Text("invalid email or password"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("Ok"))
              ],
            );
          });
    }
  }

//to set current user
  Future<void> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', email);
  }
}
