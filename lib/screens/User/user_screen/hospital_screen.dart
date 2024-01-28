// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medimate/screens/Admin/db/hospital_function.dart';
import 'package:medimate/screens/Admin/model/hospital_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/user_screen/hospital_search.dart';

class HospitalPage extends StatefulWidget {
  const HospitalPage({Key? key}) : super(key: key);

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getHospitals();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: backBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Hospital",
              style: appBarTitleStyle(),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: HospitalSearchDelegate());
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    // Listing hospitals
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 580,
                        child: ValueListenableBuilder(
                          valueListenable: hospitalListNotifier,
                          builder: (BuildContext ctx,
                              List<HospitalModel> hospitalList, Widget? child) {
                            // Search part
                            final filteredHospitals = _searchController
                                    .text.isEmpty
                                ? hospitalList
                                : hospitalList
                                    .where((hospital) => hospital.hos
                                        .toLowerCase()
                                        .contains(_searchController.text
                                            .toLowerCase()))
                                    .toList();

                            if (hospitalList.isEmpty) {
                              return Center(
                                child: Text(
                                  "Will be updated soon",
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: const Color.fromARGB(
                                        255, 195, 195, 195),
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              itemBuilder: ((context, index) {
                                final data = hospitalList[index];
                                return Container(
                                  decoration: backBoxDecoration(),
                                  child: ListTile(
                                    horizontalTitleGap: 20,
                                    contentPadding: EdgeInsets.all(5),
                                    title: Align(
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: FileImage(
                                              File(data.photo),
                                            ),
                                          ),
                                          Text(
                                            data.hos,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                          ),
                                          Text(
                                            data.loc,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                          ),
                                          Text(
                                            data.specialization,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              separatorBuilder: (context, index) => SizedBox(
                                  height: 10), // Add space between items
                              itemCount: filteredHospitals.length,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
