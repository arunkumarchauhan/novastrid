import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton(
      {super.key,
      required this.onPresed,
      required this.icon,
      this.backgroundColor});
  final Function onPresed;
  final IconData icon;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPresed(),
      child: Container(
        height: 30,
        width: 36,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        color: backgroundColor ?? Colors.white,
        child: Icon(
          icon,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
