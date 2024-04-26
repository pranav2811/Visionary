// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obsecureText;
  final IconData prefixIconData;
  final Color prefixIconColor;
  final double textFieldHeight;
  final double textFieldWidth;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecureText,
    required this.prefixIconData,
    required this.prefixIconColor,
    required this.textFieldHeight,
    required this.textFieldWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: SizedBox(
        height: textFieldHeight,
        width: textFieldWidth,
        child: TextField(
          controller: controller,
          obscureText: obsecureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(
              prefixIconData,
              color: prefixIconColor,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
