// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/db/doctorfunction.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/model/wishlist_model.dart';

import 'package:medimate/screens/User/user_screen/doctor_details.dart';
import 'package:medimate/screens/User/user_screen/doctor_search.dart';
import 'package:medimate/screens/User/user_screen/wish_screen.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDoctor();
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
              "Doctor",
              style: appBarTitleStyle(),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: DoctorSearchDelegate(),
                  );
                },
                icon: Icon(Icons.search),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Listing doctors
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 580,
                        child: ValueListenableBuilder(
                          valueListenable: doctorListNotifier,
                          builder: (BuildContext ctx,
                              List<DoctorModel> doctorList, Widget? child) {
                            // Search part
                            final filteredDoctors =
                                _searchController.text.isEmpty
                                    ? doctorList
                                    : doctorList
                                        .where((doctor) => doctor.name
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase()))
                                        .toList();

                            if (doctorList.isEmpty) {
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
                              itemBuilder: (context, index) {
                                final data = doctorList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorDetailPage(doctor: data),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: backBoxDecoration(),
                                    child: ListTile(
                                      horizontalTitleGap: 20,
                                      contentPadding: EdgeInsets.all(5),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: FileImage(
                                              File(data.photo),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Dr. ${data.name}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                          ),
                                          Text(
                                            "Specialization: ${data.specialization}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                          ),
                                          Text("Experience: ${data.experience}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromARGB(
                                                    255, 0, 0, 0),
                                              )),
                                          Text(
                                            "Hospital: ${data.hospital}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.favorite_outline_outlined,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          addToWishlist(data);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WishlistPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10),
                              itemCount: filteredDoctors.length,
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

  void addToWishlist(DoctorModel doctor) async {
  try {
    var wishlistBox = await Hive.openBox<WishlistModel>('wishlist');

    var wishlistItem = WishlistModel(
      doctorId: doctor.id,
      doctorDetails: doctor,
    );

    wishlistBox.put(doctor.id, wishlistItem);

    print('Doctor added to wishlist: ${doctor.id}');
  } catch (e) {
    print('Error adding doctor to wishlist: $e');
  }
}
}
