// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medimate/screens/Admin/admin_screen/appopintments.dart';
import 'package:medimate/screens/Admin/admin_screen/doctor/doctor_list.dart';
import 'package:medimate/screens/Admin/admin_screen/hospitalmanage.dart';
import 'package:medimate/screens/Admin/admin_screen/locationmanage.dart';
import 'package:medimate/screens/Admin/admin_screen/specialmanage_screen.dart';
import 'package:medimate/screens/Admin/db/appointment_functions.dart';
import 'package:medimate/screens/Admin/db/doctorfunction.dart';
import 'package:medimate/screens/Admin/db/hospital_function.dart';
import 'package:medimate/screens/Admin/db/location_function.dart';
import 'package:medimate/screens/Admin/db/special_function.dart';
import 'package:medimate/screens/Guest/db/user_function.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "STATISTICS",
            style: appBarTitleStyle(),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  switch (index) {
                    //User Count
                    case 0:
                      return Container(
                        decoration: statsContainer(),
                        child: FutureBuilder<int>(
                          future: userStats(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              final userCount = snapshot.data!;
                              return Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'USERS',
                                    style: statisticsCardTitle(),
                                  ),
                                  Text(
                                    '$userCount',
                                    style: statisticsCardCount(),
                                  ),
                                ],
                              ));
                            }
                          },
                        ),
                      );
                    //Doctor Count
                    case 1:
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorListPage(),
                              ));
                        },
                        child: Container(
                          decoration: statsContainer(),
                          child: FutureBuilder<int>(
                            future: doctorStats(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                final docCount = snapshot.data!;
                                return Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'DOCTORS',
                                      style: statisticsCardTitle(),
                                    ),
                                    Text(
                                      '$docCount',
                                      style: statisticsCardCount(),
                                    ),
                                  ],
                                ));
                              }
                            },
                          ),
                        ),
                      );
                    //Hospital Count
                    case 2:
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HospitalManagePage()));
                        },
                        child: Container(
                          decoration: statsContainer(),
                          child: FutureBuilder<int>(
                            future: hospitalStats(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                final hospitalCount = snapshot.data!;
                                return Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'HOSPITAL',
                                      style: statisticsCardTitle(),
                                    ),
                                    Text(
                                      '$hospitalCount',
                                      style: statisticsCardCount(),
                                    ),
                                  ],
                                ));
                              }
                            },
                          ),
                        ),
                      );
                    //Special Count
                    case 3:
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SpecialPage()));
                        },
                        child: Container(
                          decoration: statsContainer(),
                          child: FutureBuilder<int>(
                            future: specialStats(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                final specialCount = snapshot.data!;
                                return Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SPECIALIZATIONS',
                                      style: statisticsCardTitle(),
                                    ),
                                    Text(
                                      '$specialCount',
                                      style: statisticsCardCount(),
                                    ),
                                  ],
                                ));
                              }
                            },
                          ),
                        ),
                      );
                    //Location Count
                    case 4:
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationManagePage()));
                        },
                        child: Container(
                          decoration: statsContainer(),
                          child: FutureBuilder<int>(
                            future: locationStats(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                final locationCount = snapshot.data!;
                                return Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'LOCATION',
                                      style: statisticsCardTitle(),
                                    ),
                                    Text(
                                      '$locationCount',
                                      style: statisticsCardCount(),
                                    ),
                                  ],
                                ));
                              }
                            },
                          ),
                        ),
                      );
//Appo count
                    case 5:
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppointmentViewPage()));
                        },
                        child: Container(
                          decoration: statsContainer(),
                          child: FutureBuilder<int>(
                            future: appointmentStats(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                final appointmentCount = snapshot.data!;
                                return Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Appointments',
                                      style: statisticsCardTitle(),
                                    ),
                                    Text(
                                      '$appointmentCount',
                                      style: statisticsCardCount(),
                                    ),
                                  ],
                                ));
                              }
                            },
                          ),
                        ),
                      );
                    default:
                      return Container(); // Return an empty container for other indices
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
