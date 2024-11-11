import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  // PARAMETERS NEEDED
  final String textLabel;
  final VoidCallback onPressed;

  // CONSTRUCTORS FOR CREATING NEW INSTANCE/OBJECT
  const CustomFloatingActionButton({
    super.key,
    required this.textLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      icon: const Icon(
        Icons.add,
        color: Color(0xFFF5F5F5),
        size: 20,
      ),
      label: Text(
        textLabel,
        style: const TextStyle(
          color: Color(0xFFF5F5F5),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: const Color(0xFF133c0b),
    );
  }
}
