// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:medimate/screens/Guest/model/user_model.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class CustomDisplay extends StatelessWidget {
  CustomDisplay({
    this.displayColor,
    this.textColor,
    required this.textData,
    super.key,
    required this.currentUser,
  });

  Color? displayColor;
  double? borderRadius;
  Color? textColor;
  String textData;

  final UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      //Book
      Container(
        alignment: Alignment.center,
        height: 50,
        width: 330,
        decoration: profileBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(textData)],
        ),
      ),
    ]);
  }
}
