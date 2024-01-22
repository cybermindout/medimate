// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Box<DoctorModel> wishlistBox;

  @override
  void initState() {
    super.initState();
    openWishlistBox();
  }

  Future<void> openWishlistBox() async {
    wishlistBox = await Hive.openBox<DoctorModel>('wishlist');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: _buildWishlist(),
    );
  }

  Widget _buildWishlist() {
    if (wishlistBox.isEmpty) {
      return Center(
        child: Text('Your wishlist is empty.'),
      );
    }

    return ListView.builder(
      itemCount: wishlistBox.length,
      itemBuilder: (context, index) {
        DoctorModel doctor = wishlistBox.getAt(index)!;
        return _buildDoctorTile(doctor);
      },
    );
  }

  Widget _buildDoctorTile(DoctorModel doctor) {
    return ListTile(
      title: Text(doctor.name),
      subtitle: Text(doctor.specialization),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          removeFromWishlist(doctor.id!);
        },
      ),
      onTap: () {
        // Handle tapping on a doctor in the wishlist
      },
    );
  }

  void removeFromWishlist(int doctorId) {
    wishlistBox.delete(doctorId);
    setState(() {});
  }
}