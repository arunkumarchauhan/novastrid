import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.onPresed,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  });
  final Function onPresed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPresed(),
      child: Container(
        height: 30,
        width: 36,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        color: backgroundColor ?? Colors.white,
        child: Icon(
          icon,
          color: iconColor ?? Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
