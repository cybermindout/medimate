// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medimate/screens/Guest/guest_screen/login_screen.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/user_screen/editprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userEmail = '';
  UserModel? currentUser;

  int age = 0;

  @override
  void initState() {
    super.initState();
    // Call the getUser function when the page is initialized
    getUser().then((_) {
      calculateAge();
    });
  }

  Future<void> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    //if(currentUser != null)
    userEmail = prefs.getString('currentUser') ?? '';
    // check the user in Hive using the email
    final userBox = await Hive.openBox<UserModel>('user_db');
    currentUser = userBox.values.firstWhere(
      (user) => user.email == userEmail,
      //orElse: () => null,
    );
    setState(() {});
  }

  void calculateAge() {
    if (currentUser != null) {
      String dobString = currentUser!.dob;
      DateTime dob = DateFormat('MM-dd-yyyy').parse(dobString);

      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(dob);
      age = (difference.inDays / 365).floor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: SingleChildScrollView(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "PROFILE PAGE",
              style: appBarTitleStyle(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Navigate to the edit page when the edit button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfilePage(currentUser: currentUser),
                    ),
                  );
                },
              ),
            ],
          ),
          body: currentUser != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 10, 0),
                    child: Align(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.person,
                              color: Colors.deepPurple,
                            ),
                            title: Text(
                              currentUser!.fullname,
                              style: ProfileTextStyle(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.email,
                              color: Colors.red[400],
                            ),
                            title: Text(
                              currentUser!.email,
                              style: ProfileTextStyle(),
                            ),
                          ),
                          ListTile(
                            leading: getGenderIcon(currentUser!.gender),
                            title: Text(
                              currentUser!.gender,
                              style: ProfileTextStyle(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.calendar_month,
                              color: Colors.green,
                            ),
                            title: Text(
                              currentUser!.dob,
                              style: ProfileTextStyle(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.date_range_outlined,
                              color: Colors.amber,
                            ),
                            title: Text(
                              "$age Years",
                              style: ProfileTextStyle(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.bloodtype,
                              color: Colors.red,
                            ),
                            title: Text(
                              currentUser!.bloodGroup,
                              style: ProfileTextStyle(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.phone,
                              color: Colors.green,
                            ),
                            title: Text(
                              currentUser!.phone,
                              style: ProfileTextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Text("USER NOT LOGGED IN"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ));
                            },
                            child: Text("PROCEED TO LOGIN"))
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
