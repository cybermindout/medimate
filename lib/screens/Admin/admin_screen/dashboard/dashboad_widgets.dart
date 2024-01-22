import 'package:flutter/material.dart';
import 'package:medimate/screens/Styles/decoration.dart';

class CustomDashItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const CustomDashItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildMenuItem(icon, label, onPressed);
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onPressed) {
    return Container(
      alignment: Alignment.center,
      height: 150,
      width: 150,
      decoration: menuBoxDecoration(),
      child: Column(
        children: [
          TextButton(
            onPressed: onPressed,
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
