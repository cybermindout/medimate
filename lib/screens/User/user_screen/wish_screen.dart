// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Styles/decoration.dart';
import 'package:medimate/screens/User/model/wishlist_model.dart';
import 'package:medimate/screens/User/user_screen/doctor_details.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Wishlist'),
        ),
        body: FutureBuilder(
          future: Hive.openBox<WishlistModel>('wishlist'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var wishlistBox = Hive.box<WishlistModel>('wishlist');
              List<int> wishlistDoctorIds =
                  wishlistBox.keys.cast<int>().toList();

              return ListView.builder(
                itemCount: wishlistDoctorIds.length,
                itemBuilder: (context, index) {
                  int doctorId = wishlistDoctorIds[index];
                  var wishlistItem = wishlistBox.get(doctorId);
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: backBoxDecoration(),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            backgroundImage: FileImage(
                              File(wishlistItem?.doctorDetails?.photo ?? ''),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Dr. ${wishlistItem?.doctorDetails?.name ?? ''}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Specialization :${wishlistItem?.doctorDetails?.specialization ?? ''}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Hospital :${wishlistItem?.doctorDetails?.hospital ?? ''}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          // Remove doctor from wishlist here
                          wishlistBox.delete(doctorId);
                          // Refresh UI after deletion
                          setState(() {});
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorDetailPage(
                              doctor: wishlistItem!.doctorDetails!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
