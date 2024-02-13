// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('About MediMate'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to MediMate – Your Trusted Healthcare Companion!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'At MediMate, we believe in making healthcare accessible, efficient, and convenient. Our mission is to empower individuals to take control of their health by providing a seamless platform for scheduling doctor appointments at our esteemed hospital locations.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'About Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'MediMate is a cutting-edge Flutter application designed to simplify the process of booking doctor appointments. We understand the importance of timely and reliable healthcare services, and our app is here to bridge the gap between you and the healthcare professionals you need.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
