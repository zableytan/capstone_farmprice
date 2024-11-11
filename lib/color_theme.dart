import 'package:flutter/material.dart';

const MaterialColor customThemePrimary = MaterialColor(_customThemePrimaryValue, <int, Color>{
  50: Color(0xFFE0F7EC),
  100: Color(0xFFB3EAD2),
  200: Color(0xFF80DDB5),
  300: Color(0xFF4DD097),
  400: Color(0xFF26C77E),
  500: Color(_customThemePrimaryValue),
  600: Color(0xFF00B85B),
  700: Color(0xFF00AD51),
  800: Color(0xFF00A448),
  900: Color(0xFF009435),
});
const int _customThemePrimaryValue = 0xFF00BF63;

const MaterialColor customThemeAccent = MaterialColor(_customThemeAccentValue, <int, Color>{
  100: Color(0xFFB3FFD8),
  200: Color(_customThemeAccentValue),
  400: Color(0xFF4DFFAD),
  700: Color(0xFF26FF9C),
});
const int _customThemeAccentValue = 0xFF80FFBF;
