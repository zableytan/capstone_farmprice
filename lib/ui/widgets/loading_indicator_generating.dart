import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Import the animated text package

void showLoadingIndicatorv2(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF133c0b)), // Set the color to red
            ),
            const SizedBox(width: 15),
            // Animated text with moving effect
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Generating Crop Reports...',
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF133c0b)),
                  speed: const Duration(
                      milliseconds: 150), // Adjust speed as needed
                ),
              ],
              isRepeatingAnimation: true, // Repeat the animation
            ),
          ],
        ),
      );
    },
  );
}
