// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:medimate/screens/Admin/admin_screen/appopintments.dart';
import 'package:medimate/screens/Admin/admin_screen/dashboard/dashboad_widgets.dart';
import 'package:medimate/screens/Admin/admin_screen/doctor/doctor_list.dart';
import 'package:medimate/screens/Admin/admin_screen/doctor/doctormanage.dart';
import 'package:medimate/screens/Admin/admin_screen/feedbackview.dart';
import 'package:medimate/screens/Admin/admin_screen/hospitalmanage.dart';
import 'package:medimate/screens/Admin/admin_screen/locationmanage.dart';
import 'package:medimate/screens/Admin/admin_screen/specialmanage_screen.dart';
import 'package:medimate/screens/Admin/admin_screen/statitics_screen.dart';
import 'package:medimate/screens/Guest/guest_screen/logout_screen.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0.0),
        decoration: backBoxDecoration(),
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      child: Stack(
                        children: <Widget>[
                          AppBar(
                            title: Text('dashboard'),
                            backgroundColor: Color.fromRGBO(46, 208, 151, 1),
                            toolbarHeight: 100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(30),
                              ),
                            ),
                            actions: [
                              IconButton(
                                icon: Icon(Icons.logout),
                                onPressed: () {
                                  logOut(context);
                                },
                              ),
                            ],
                          ),
                          Positioned(
                            top: 30,
                            left: 100,
                            child: Text(
                              'Dashboard',
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Container(
                          child: SizedBox(
                            width: 500,
                            child: Column(
                              children: [
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomDashItem(
                                      icon: Icons.local_hospital,
                                      label: 'Hospital',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HospitalManagePage(),
                                            ));
                                      },
                                    ),
                                    CustomDashItem(
                                      icon: Icons.star_border_outlined,
                                      label: 'Specialization',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SpecialPage(),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomDashItem(
                                      icon: Icons.group_add_outlined,
                                      label: 'Add Doctor',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddDoctor(),
                                            ));
                                      },
                                    ),
                                    CustomDashItem(
                                      icon: Icons.group_outlined,
                                      label: 'Doctor List',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DoctorListPage(),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomDashItem(
                                      icon: Icons.bar_chart,
                                      label: 'Statitics',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StatisticsPage(),
                                            ));
                                      },
                                    ),
                                    CustomDashItem(
                                      icon: Icons.bookmark_add,
                                      label: 'Appointments',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AppointmentViewPage(),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomDashItem(
                                      icon: Icons.location_on,
                                      label: 'Location',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LocationManagePage(),
                                            ));
                                      },
                                    ),
                                    CustomDashItem(
                                      icon: Icons.feedback_outlined,
                                      label: 'Feed Back',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FeedbackViewPage(),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )))));
  }
}
