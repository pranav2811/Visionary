import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ImageProvider icon;
  final double size;
  const ImageButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: size,
              height: size,
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: Image(
                image: icon,
                width: size * 0.6,
                height: size * 0.6,
              ),
            ),
          )),
    );
  }
}
