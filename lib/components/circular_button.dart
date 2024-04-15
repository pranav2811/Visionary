import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Icon icon;
  const CircularButton({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      child: RawMaterialButton(
        onPressed: () {},
        shape: CircleBorder(),
        fillColor: Colors.lightBlueAccent,
        elevation: 0.0,
        child: Icon(icon.icon, color: Colors.white),
      ),
    );
  }
}
