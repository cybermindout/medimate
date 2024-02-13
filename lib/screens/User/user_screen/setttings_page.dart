// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/main.dart';
import 'package:medimate/screens/Guest/guest_screen/login_screen.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/user_screen/abou_page.dart';
import 'package:medimate/screens/User/user_screen/feedback.dart';
import 'package:medimate/screens/User/user_screen/help_center.dart';
import 'package:medimate/screens/User/user_screen/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

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
      decoration: backBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "SETTINGS",
              style: appBarTitleStyle(),
            )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "PROFILE",
                  style: listtileTitleStyle(),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text(
                  "PRIVACY POLICY",
                  style: listtileTitleStyle(),
                ),
                onTap: () => _launchPPURL(
                    'https://www.freeprivacypolicy.com/live/3138d9d9-db48-4658-8f59-7626c7e75765'),
              ),
              ListTile(
                leading: Icon(Icons.shield),
                title: Text(
                  "TERMS AND CONDITIONS",
                  style: listtileTitleStyle(),
                ),
                onTap: () => _launchTCURL(
                    'https://www.freeprivacypolicy.com/live/71f6d9eb-e7c9-4b46-a602-a4f8f5b95adb'),
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text(
                  "HELP CENTER",
                  style: listtileTitleStyle(),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpCenterPage(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.feedback_outlined),
                title: Text(
                  "FEEDBACK",
                  style: listtileTitleStyle(),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackPage(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.question_mark_rounded),
                title: Text(
                  "About",
                  style: listtileTitleStyle(),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutPage(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text(
                  "DELETE MY ACCOUNT",
                  style: listtileTitleStyle(),
                ),
                onTap: () {
                  deleteUserButton();
                },
              ),
              ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text(
                  "LOGOUT",
                  style: listtileTitleStyle(),
                ),
                onTap: () => logOut(context),
              ),
              Spacer(),
              Column(
                children: const [Text("v.0.0.1")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.copyright,
                    color: Colors.grey,
                  ),
                  Text(
                    "MediMate 2023",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//to launch url
  void _launchPPURL(String url) async {
    Uri url = Uri.parse(
        'https://www.freeprivacypolicy.com/live/c8391423-0412-4c93-9a32-c007e7acc624');
    if (await launchUrl(url)) {
    } else {
      SnackBar(content: Text("couldn't launch the page"));
    }
  }

  void _launchTCURL(String url) async {
    Uri url = Uri.parse(
        'https://www.freeprivacypolicy.com/live/71f6d9eb-e7c9-4b46-a602-a4f8f5b95adb');
    if (await launchUrl(url)) {
    } else {
      SnackBar(content: Text("couldn't launch the page"));
    }
  }

//log out
  void logOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Logout"),
            content: Text("Do you want to leave ?"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    signout(context);
                  },
                  child: Text("Yes")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
            ],
          );
        });
  }

//signout
  signout(BuildContext ctx) async {
    final _sharedPrefs = await SharedPreferences.getInstance();
    await _sharedPrefs.clear();

    Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => LoginScreen()), (route) => false);
    _sharedPrefs.setBool(SAVE_KEY_NAME, false);
  }

//delete user
  deleteUserButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete account"),
          content: Text("The account will be deleted permanently"),
          actions: [
            ElevatedButton(
              onPressed: () {
                confirmDelete(context);
              },
              child: Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  confirmDelete(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
    });
  }
}
