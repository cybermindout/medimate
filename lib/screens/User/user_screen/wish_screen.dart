// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Styles/decoration.dart';

import 'package:medimate/screens/User/model/wishlist_model.dart';
import 'package:medimate/screens/User/user_screen/doctor_details.dart';

class WishlistPage extends StatelessWidget {
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(wishlistItem?.doctorDetails?.name ?? ''),
                      subtitle: Text(
                          wishlistItem?.doctorDetails?.specialization ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          // Remove doctor from wishlist here
                          wishlistBox.delete(doctorId);
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
