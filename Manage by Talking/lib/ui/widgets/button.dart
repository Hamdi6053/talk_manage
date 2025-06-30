
import "package:flutter/material.dart";

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueAccent,
        ),
        child: Center( // Metni ortalar
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15
            ),
          ),
        ),
      ),
    );
  }
}