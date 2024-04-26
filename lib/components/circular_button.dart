import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressedButton;
  const CircularButton({
    required this.icon,
    required this.onPressedButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      child: RawMaterialButton(
        onPressed: onPressedButton,
        shape:const CircleBorder(),
        fillColor: Colors.lightBlueAccent,
        elevation: 0.0,
        child: Icon(icon.icon, color: Colors.white),
      ),
    );
  }
}
