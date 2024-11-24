import 'package:flutter/material.dart';
import 'package:myapp/ui/screens/admin_screen/login_screen.dart';
import 'package:myapp/ui/screens/basic_user_screen/login_user_account.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'package:myapp/ui/widgets/custom_image_display.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          // APP LOGO
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 50, bottom: 20), // Adjust top margin to add spacing
              child: CustomImageDisplay(
                imageSource: "lib/ui/assets/farm_price_logo.png",
                imageHeight: screenHeight * 0.4,
                imageWidth: screenWidth * 0.6,
              ),
            ),
          ),

          // CONTINUE BUTTON
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
            child: CustomButton(
              buttonLabel: "Continue",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginUserAccount(),
                  ),
                );
              },
              buttonColor: const Color(0xFF39590e),
              buttonHeight: 45,
              fontWeight: FontWeight.w500,
              fontSize: 15,
              fontColor: Colors.white,
              borderRadius: 10,
            ),
          ),

          // SPACING BETWEEN BUTTONS
          const Spacer(),

          // ADMIN ACCESS BUTTON - MOVED ABOVE PARTNERS
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white, // White background
                foregroundColor: const Color(0xFF78AB78), // Border and text color
                side: const BorderSide(color: Color(0xFF78AB78), width: 2), // Border color and thickness
                padding: const EdgeInsets.symmetric(
                  vertical: 12,  // Adjust the vertical padding
                  horizontal: 20,  // Adjust the horizontal padding here
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),  // Rounded corners
                ),
              ),
              child: const Text(
                "ADMIN ACCESS",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),


          // PARTNERS SECTION - Now below the Admin Button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Column(
              children: [
                Text(
                  "Our Partners",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF133c0b),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // DFTC Logo
                    CustomImageDisplay(
                      imageSource: "lib/ui/assets/dftc_logo.jpg",
                      imageHeight: 50,
                      imageWidth: 50,
                    ),
                    SizedBox(width: 20),
                    // Department of Agriculture Logo
                    CustomImageDisplay(
                      imageSource: "lib/ui/assets/da_logo.png",
                      imageHeight: 50,
                      imageWidth: 50,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Davao Food Terminal Complex - DFTC\nDepartment of Agriculture",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // SPACING
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
