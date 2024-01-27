// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

BoxDecoration menuBoxDecoration() => BoxDecoration(
        color: Color.fromRGBO(46, 208, 151, 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 3,
            color: Color.fromARGB(255, 92, 92, 92).withOpacity(.5),
          )
        ]);

BoxDecoration profileBoxDecoration() => BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 3,
            color: Color.fromARGB(255, 92, 92, 92).withOpacity(.5),
          )
        ]);

BoxDecoration backBoxDecoration() => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromRGBO(14, 190, 127, 1),
          Colors.white,
          Color.fromARGB(255, 216, 255, 217),
        ],
      ),
      borderRadius: BorderRadius.circular(10),
    );

BoxDecoration locationDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 3,
            color: Color.fromARGB(255, 92, 92, 92).withOpacity(.5),
          )
        ]);

TextStyle headingsTextStyle() => TextStyle(
    color: Color.fromARGB(255, 0, 0, 0),
    fontWeight: FontWeight.w700,
    fontSize: 18);

TextStyle appBarTitleStyle() => GoogleFonts.rubik(
    fontWeight: FontWeight.w400,
    letterSpacing: 1,
    fontSize: 18,
    color: const Color.fromARGB(255, 40, 39, 39).withOpacity(0.7));

Icon getGenderIcon(String gender) {
  if (gender.toLowerCase() == 'male') {
    return Icon(Icons.male, color: Colors.blue);
  } else if (gender.toLowerCase() == 'female') {
    return Icon(Icons.female, color: Colors.pink);
  } else {
    return Icon(Icons.person, color: Colors.grey);
  }
}

TextStyle doctorListTitle() =>
    TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

//doctor list subtitle
TextStyle doctorListSubtitle() =>
    TextStyle(fontWeight: FontWeight.w500, fontSize: 15);

TextStyle doctorDetailSubtitle() =>
    TextStyle(fontWeight: FontWeight.w500, fontSize: 20);

//Statistics card counts
TextStyle statisticsCardCount() => TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w700,
    color: Color.fromARGB(255, 16, 241, 151));
//Statistics card title
TextStyle statisticsCardTitle() =>
    TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black);

//Statistics container
BoxDecoration statsContainer() => BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 3,
            color: Color.fromARGB(255, 92, 92, 92).withOpacity(.5),
          )
        ]);
