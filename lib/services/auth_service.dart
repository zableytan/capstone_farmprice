import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/ui/screens/admin_screen/admin_home_screen.dart';
import 'package:myapp/ui/screens/basic_user_screen/user_home_screen.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator.dart';

class AuthService {
  // SIGN IN AUTHENTICATION
  Future<bool> signIn({
    required BuildContext context,
    required String username,
    required String password,
    required String userType,
  }) async {
    try {
      // SHOW LOADING INDICATOR
      showLoadingIndicator(context);

      // SIGN IN USING USERNAME AND PASSWORD
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username.trim(),
        password: password.trim(),
      );

      // Navigate to the correct home screen
      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading indicator

        if (userType == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AdminHomeScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const UserHomeScreen(),
            ),
          );
        }
      }

      return true; // Login successful
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException errors
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage =
        'Account not found. Please check your username and try again.';
      } else {
        errorMessage = 'Incorrect username or password. Please try again.';
      }

      // Display error message if authentication fails
      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading indicator
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
      return false; // Login failed
    } catch (e) {
      // Handle other unexpected errors
      debugPrint('Error signing in: $e');

      // Display generic error message to the user
      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading indicator
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error signing in: $e')));
      }
      return false; // Login failed
    }
  }
}
