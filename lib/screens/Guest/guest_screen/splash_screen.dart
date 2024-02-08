// ignore_for_file: camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, unnecessary_cast, dead_code, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medimate/screens/Guest/guest_screen/login_screen.dart';
import 'package:medimate/screens/User/user_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medimate/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              child: Lottie.network(
                  'https://lottie.host/86ee80b2-e5e5-4ccb-8c51-8104f5a44d25/aDk4jpQQdv.json',
                  width: 350),
            ),
          ),
        ));
  }

  Future<void> gotoLogin() async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }

  Future<void> checkUserLoggedIn() async {
    final _sharedprefs = await SharedPreferences.getInstance();
    final _userLoggedIn = _sharedprefs.getBool(SAVE_KEY_NAME);
    if (_userLoggedIn == null || _userLoggedIn == false) {
      gotoLogin();
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => HomeScreen()));
    }
  }
}
