// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class DoctorDetailPage extends StatelessWidget {
  final DoctorModel doctor;

  DoctorDetailPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(46, 208, 151, 1),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(35)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Specialization: ${doctor.specialization}",
                          style: doctorDetailSubtitle(),
                        ),
                        Text("Experience: ${doctor.experience}",
                            style: doctorDetailSubtitle()),
                        Text("Hospital: ${doctor.hospital}",
                            style: doctorDetailSubtitle()),
                        Text("Consulting Days: ${doctor.consultingdays}",
                            style: doctorDetailSubtitle()),
                        Text(
                            "Consulting Start Time: ${doctor.consultingStartTime}",
                            style: doctorDetailSubtitle()),
                        Text("Consulting End Time: ${doctor.consultingEndTime}",
                            style: doctorDetailSubtitle()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 30,
              left: 16,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 90,
              left: 110,
              child: Column(
                children: [
                  // Circle Avatar to display doctor image
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: FileImage(
                      File(doctor.photo),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Doctor name below the image
                  Text(
                    "Dr. ${doctor.name}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
