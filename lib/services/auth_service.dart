import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/ui/screens/admin_screen/admin_home_screen.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator.dart';

class AuthService {
  // SIGN IN AUTHENTICATION
  Future signIn({
    // PARAMETER
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
      // SHOW LOADING INDICATOR
      if (context.mounted) {
        showLoadingIndicator(context);
      }

      // SING IN USING USERNAME AND PASSWORD
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username.trim(),
        password: password.trim(),
      );

      // DISMISS LOADING INDICATOR
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const AdminHomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException errors
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage =
            'Account not found. Please check your username and try again.';
      } else {
        errorMessage = 'Incorrect username or password. Please try again.';
      }
      // UPDATE ERROR MESSAGE
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }

      // DISMISS LOADING DIALOG
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
    } catch (e) {
      // Handle other errors
      debugPrint('Error signing in: $e');

      // DISPLAY ERROR MESSAGE TO THE USER
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error signing in: $e')));
      }

      // DISMISS LOADING DIALOG
      if (context.mounted) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      }
    }
  }
}
