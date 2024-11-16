// ignore: file_names
import 'package:flutter/material.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/ui/screens/basic_user_screen/user_home_screen.dart';

class LoginUserAccount extends StatefulWidget {
  const LoginUserAccount({super.key});

  @override
  State<LoginUserAccount> createState() => _LoginUserAccountState();
}

class _LoginUserAccountState extends State<LoginUserAccount> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _authLogin);
  }

  // FUNCTION TO AUTHENTICATE LOGIN
  Future<void> _authLogin() async {
    try {
      final success = await AuthService().signIn(
        context: context,
        username: "aaaaa@aaaaa.aaaaa",
        password: "aaaaaa",
        userType: "user",
      );

      // Navigate based on the result of the signIn function
      if (success) {
        // Navigate to the correct home screen based on userType
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const UserHomeScreen(),
            ),
          );
        }
      } else {
        // If login fails, you could handle it here (e.g., navigate to an error screen)
      }
    } catch (e) {
      // Catch any unexpected errors and handle them here (e.g., showing an error screen)
      debugPrint("Login failed: ${e.toString()}");
      // You can add navigation to an error screen if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(),
    ); // Empty widget, as there's no UI to show
  }
}
