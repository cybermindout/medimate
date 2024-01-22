// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class HomeCards extends StatelessWidget {
  HomeCards({
    required this.onPressed,
    required this.textCards,
    this.textColor,
    required this.iconCards,
    super.key,
  });

  VoidCallback? onPressed;
  Color? textColor;
  String textCards;
  IconData iconCards;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      //Card1
      Container(
        alignment: Alignment.center,
        height: 150,
        width: 150,
        decoration: menuBoxDecoration(),
        child: Column(children: [
          TextButton(
              onPressed: () {},
              child: Column(
                children: [
                  Icon(iconCards),
                  Text(textCards),
                ],
              ))
        ]),
      ),
    ]);
  }
}
