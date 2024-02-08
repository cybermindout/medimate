// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/user_screen/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HELP CENTER",
          style: appBarTitleStyle(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Text("Write to Us !"),
            Text(""),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: validateEmpty,
                        controller: _subjectController,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Subject"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: validateEmpty,
                        controller: _bodyController,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Content"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            launchEmail();
                          },
                          child: Text("Sent"))
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  //to validate cannot be empty
  String? validateEmpty(String? value) {
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

//to send email
  Future<void> launchEmail() async {
    if (_formKey.currentState!.validate()) {
      final subject = _subjectController.text.trim();
      final body = _bodyController.text.trim();
      final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: 'hiddred@gmail.com',
          query: 'body=$body&subject=$subject');
      await launchUrl(emailLaunchUri);
      _subjectController.clear();
      _bodyController.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);
    }
  }
}
