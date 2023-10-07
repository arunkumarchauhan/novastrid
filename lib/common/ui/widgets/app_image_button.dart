import 'package:flutter/material.dart';

class AppImageButton extends StatelessWidget {
  const AppImageButton({
    super.key,
    required this.onPresed,
    required this.imagePath,
    this.backgroundColor,
  });
  final Function onPresed;
  final String imagePath;
  final Color? backgroundColor;

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
        child: Image.asset(
          imagePath,
          height: 20,
          width: 20,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
