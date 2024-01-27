// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:medimate/screens/User/model/wishlist_model.dart';
import 'package:medimate/screens/User/user_screen/doctor_details.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                  return ListTile(
                    title: Text(wishlistItem?.doctorDetails?.name ?? ''),
                    subtitle:
                        Text(wishlistItem?.doctorDetails?.specialization ?? ''),
                    onTap: () {
                      // Navigate to DoctorDetailPage when tapping on a doctor in the wishlist
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailPage(
                              doctor: wishlistItem!.doctorDetails!),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
