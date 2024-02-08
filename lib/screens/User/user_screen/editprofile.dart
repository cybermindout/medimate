// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medimate/screens/Guest/db/user_function.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel? currentUser;

  const EditProfilePage({Key? key, this.currentUser}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  List<String> genderOptions = ['Male', 'Female', 'Not to specify'];
  String? selectedGender;
  String? id;

  List<String> bloodGroupOptions = ['A+', 'B+', 'O+', 'AB+', 'O-', 'Other'];
  String? selectedBloodGroup;

  @override
  void initState() {
    super.initState();
    id = widget.currentUser?.id.toString();
    _fullNameController.text = widget.currentUser?.fullname ?? '';
    _emailController.text = widget.currentUser?.email ?? '';
    _dobController.text = widget.currentUser?.dob ?? '';
    _genderController.text = widget.currentUser?.gender ?? '';
    _bloodGroupController.text = widget.currentUser?.bloodGroup ?? '';
    _phoneController.text = widget.currentUser?.phone ?? '';
    selectedGender = _genderController.text;
    selectedBloodGroup = _bloodGroupController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Edit Profile"),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveChanges();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                readOnly: true,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: selectedGender,
                items: genderOptions.map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Gender',
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField(
                value: selectedBloodGroup,
                items: bloodGroupOptions.map((String bloodGroup) {
                  return DropdownMenuItem<String>(
                    value: bloodGroup,
                    child: Text(bloodGroup),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBloodGroup = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Blood Group',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _saveChanges() {
    final id = int.tryParse(widget.currentUser?.id.toString() ?? '0') ?? 0;
    editUser(
      id,
      _fullNameController.text,
      _emailController.text,
      selectedGender ?? '',
      _dobController.text,
      selectedBloodGroup ?? '',
      _phoneController.text,
    );
    Navigator.pop(context, true); // Notify that changes were saved
  }
}
