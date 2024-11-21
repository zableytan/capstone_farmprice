import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/color_theme.dart';
import 'package:myapp/ui/screens/landing_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: customThemePrimary,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFF279778),
            selectionColor: Color(0xFF279778),
            selectionHandleColor: Color(0xFF279778),
          )),
      home: const LandingScreen(),
    );
  }
}
