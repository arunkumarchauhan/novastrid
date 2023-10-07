import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.maxLines = 1,
    this.textInputType,
    this.textStyle,
    this.textAlign,
    this.textAlignVertical,
  });
  final TextStyle? textStyle;
  final TextAlignVertical? textAlignVertical;
  final TextAlign? textAlign;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? textInputType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: textInputType,
      style: textStyle,
      textAlignVertical: textAlignVertical,
      textAlign: textAlign ?? TextAlign.left,
      decoration: const InputDecoration(
          border: InputBorder.none, contentPadding: EdgeInsets.all(10)),
    );
  }
}
