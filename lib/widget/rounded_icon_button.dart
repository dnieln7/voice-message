import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  RoundedIconButton({
    required this.icon,
    this.iconColor = Colors.white,
    this.background = Colors.black,
    required this.action,
  });

  final IconData icon;
  final Color iconColor;
  final Color background;
  final Function()? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: background,
      ),
      margin: const EdgeInsets.only(bottom: 10, right: 10),
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        child: Icon(icon, color: iconColor),
        onTap: action,
      ),
    );
  }
}
