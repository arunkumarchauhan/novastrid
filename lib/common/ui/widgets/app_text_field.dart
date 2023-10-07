import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      required this.controller,
      this.maxLines = 1,
      this.textInputType});
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? textInputType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: textInputType,
      decoration: const InputDecoration(
          border: InputBorder.none, contentPadding: EdgeInsets.all(10)),
    );
  }
}
