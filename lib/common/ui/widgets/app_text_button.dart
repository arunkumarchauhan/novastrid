import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton(
      {super.key, required this.onPresed, required this.text, this.textStyle});
  final Function onPresed;
  final String text;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPresed(),
      child: Text(
        text,
        style: textStyle ??
            const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
      ),
    );
  }
}
