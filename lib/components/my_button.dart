import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  MyButton({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 130),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
