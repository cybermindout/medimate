// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medimate/screens/Guest/guest_screen/login_screen.dart';

logOut(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log Out"),
          content: Text("Are you sure ?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false);
                },
                child: Text("Confirm")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"))
          ],
        );
      });
}
