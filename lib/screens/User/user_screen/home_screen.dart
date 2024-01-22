// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Guest/guest_screen/logout_screen.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/user_screen/doctor_screen.dart';
import 'package:medimate/screens/User/user_screen/hospital_screen.dart';
import 'package:medimate/screens/User/user_screen/location_screen.dart';
import 'package:medimate/screens/User/user_screen/profile_screen.dart';
import 'package:medimate/screens/User/user_screen/search_filter.dart';
import 'package:medimate/screens/User/user_screen/specialization_screen.dart';
import 'package:medimate/screens/User/user_screen/wish_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                body: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      child: Stack(
                        children: <Widget>[
                          AppBar(
                            title: Text(''),
                            backgroundColor: Color.fromRGBO(46, 208, 151, 1),
                            toolbarHeight: 150,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(30),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            left: 10,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Hi ${currentUser?.fullname ?? ""}',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontFamily: 'Rubik'),
                              ), // Display name
                            ),
                          ),
                          Positioned(
                            top: 90,
                            left: 20,
                            child: Container(
                              width: 350,
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('Search'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CarouselSlider(
                          options: CarouselOptions(
                            height: 200,
                            viewportFraction: 0.95,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1000),
                            autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                          ),
                          items: [
                            Container(
                              child: Center(
                                  child: Image.asset(
                                'assets/images/banner1.jpg',
                                fit: BoxFit.fill,
                              )),
                            ),
                            Container(
                              child: Center(
                                  child:
                                      Image.asset('assets/images/banner1.jpg')),
                            ),
                            Container(
                              child: Center(
                                  child:
                                      Image.asset('assets/images/banner1.jpg')),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
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
                                  //Book
                                  Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 330,
                                    decoration: menuBoxDecoration(),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LocationPage(),
                                                    ));
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  Text(" Locations",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center),
                                                ],
                                              ))
                                        ]),
                                  ),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //Hospital
                                  Container(
                                    alignment: Alignment.center,
                                    height: 150,
                                    width: 150,
                                    decoration: menuBoxDecoration(),
                                    child: Column(children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HospitalPage(),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.local_hospital_outlined,
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                              Text(" Hospitals",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ))
                                    ]),
                                  ),
                                  //Speacialization
                                  Container(
                                    alignment: Alignment.center,
                                    height: 150,
                                    width: 150,
                                    decoration: menuBoxDecoration(),
                                    child: Column(children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SpecializationPage(),
                                                ));
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.star_border,
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                              Text(" Specialization",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ))
                                    ]),
                                  ),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //Doctors
                                  Container(
                                    alignment: Alignment.center,
                                    height: 150,
                                    width: 150,
                                    decoration: menuBoxDecoration(),
                                    child: Column(children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DoctorPage(),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.groups_outlined,
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                              Text(" Doctors",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ))
                                    ]),
                                  ),
                                  //Appointments
                                  Container(
                                    alignment: Alignment.center,
                                    height: 150,
                                    width: 150,
                                    decoration: menuBoxDecoration(),
                                    child: Column(children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchPage()),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons
                                                    .collections_bookmark_rounded,
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                              Text(" Appointments",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ))
                                    ]),
                                  ),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //Doctors
                                  Container(
                                    alignment: Alignment.center,
                                    height: 150,
                                    width: 150,
                                    decoration: menuBoxDecoration(),
                                    child: Column(children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WishlistPage()),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                size: 100,
                                                color: Colors.white,
                                              ),
                                              Text(" WishList",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ))
                                    ]),
                                  ),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  //Book
                                  Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 330,
                                    decoration: menuBoxDecoration(),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                logOut(context);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.logout_outlined,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  Text(" LogOut",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center),
                                                ],
                                              ))
                                        ]),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                )))));
  }
}
