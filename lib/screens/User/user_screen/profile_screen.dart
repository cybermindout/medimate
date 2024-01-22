// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_string_interpolations, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/Styles/custom_display.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userEmail = '';
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('currentUser') ?? '';
    final userBox = await Hive.openBox<UserModel>('user_db');
    currentUser = userBox.values.firstWhere(
      (user) => user.email == userEmail,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: backBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: currentUser != null
              ? SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      AppBar(
                        title: Text(
                          'Profile',
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.transparent,
                        toolbarHeight: 80,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(30),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                              child: Column(children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomDisplay(
                              currentUser: currentUser,
                              textData: "${currentUser!.fullname}",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomDisplay(
                              currentUser: currentUser,
                              textData: "${currentUser!.phone}",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomDisplay(
                              currentUser: currentUser,
                              textData: "${currentUser!.email}",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomDisplay(
                              currentUser: currentUser,
                              textData: "${currentUser!.dob}",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomDisplay(
                              currentUser: currentUser,
                              textData: "${currentUser!.gender}",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomDisplay(
                              currentUser: currentUser,
                              textData: "${currentUser!.bloodGroup}",
                            ),
                          ]))),
                    ]))
              : Center(),
        ),
      ),
    );
  }
}
