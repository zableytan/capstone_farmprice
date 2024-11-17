import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:myapp/ui/screens/admin_screen/crop_reports/crop_reports_screen.dart';
import 'package:myapp/ui/screens/admin_screen/crops/crops_screen.dart';
import 'package:myapp/ui/screens/admin_screen/market_trends/market_trends_screen.dart';
import 'package:myapp/ui/screens/admin_screen/markets/markets_screen.dart';
import 'package:myapp/ui/widgets/custom_icon.dart';
import 'package:myapp/ui/widgets/modals/custom_modals.dart';
import 'package:myapp/ui/widgets/navigation/custom_navigation.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for downloading reports

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  // Function to handle report download
  Future<void> downloadReport() async {
    const url =
        'https://script.google.com/macros/s/AKfycbx-jPw7RQdp-cNGVVJ3PSUBYiDHeTGOaxkSDNjzdjosGezQz8q7OvcWSWPpZMWHT12IJA/exec'; // Replace with your script URL

    try {
      if (await canLaunch(url)) {
        await launch(url);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Download started. Check your browser for the file.')),
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start download: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF133c0b).withOpacity(0.3),
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0.0,
          title: Row(
            children: <Widget>[
              const CustomIcon(
                imagePath: 'lib/ui/assets/admin_icon.png',
                size: 30,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: AutoSizeText(
                  "Welcome to FarmPrice!",
                  style: TextStyle(
                    color: Color(0xFF3C4D48),
                    fontWeight: FontWeight.bold,
                  ),
                  minFontSize: 13,
                  maxFontSize: 15,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  showLogoutModal(context);
                },
                icon: const Icon(Icons.logout_rounded),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 17,
            top: 10,
            right: 17,
          ),
          child: Column(
            children: <Widget>[
              // MARKETS
              _buildButtonContainers(
                () {
                  navigateWithSlideFromRight(
                    context,
                    const MarketsScreen(),
                    1.0,
                    0.0,
                  );
                },
                'lib/ui/assets/market_icon.png',
                "Markets",
                17,
                FontWeight.normal,
                Colors.white,
                const Color(0xFF133c0b),
                8,
              ),
              // CROP REPORT
              _buildButtonContainers(
                () {
                  navigateWithSlideFromRight(
                    context,
                    const CropReportsScreen(),
                    1.0,
                    0.0,
                  );
                },
                'lib/ui/assets/crops_report_icon.png',
                "Crop Reports",
                17,
                FontWeight.normal,
                Colors.white,
                const Color(0xFF133c0b),
                8,
              ),
              // CROPS
              _buildButtonContainers(
                () {
                  navigateWithSlideFromRight(
                    context,
                    const CropsScreen(),
                    1.0,
                    0.0,
                  );
                },
                'lib/ui/assets/crops_icon.png',
                "Crops",
                17,
                FontWeight.normal,
                Colors.white,
                const Color(0xFF133c0b),
                8,
              ),
              // MARKET TRENDS
              _buildButtonContainers(
                () {
                  navigateWithSlideFromRight(
                    context,
                    const MarketTrendsScreen(),
                    1.0,
                    0.0,
                  );
                },
                'lib/ui/assets/market_trends_icon.png',
                "Market Trends",
                17,
                FontWeight.normal,
                Colors.white,
                const Color(0xFF133c0b),
                8,
              ),
              // DOWNLOAD REPORT
              _buildButtonContainers(
                downloadReport,
                'lib/ui/assets/report_icon.png', // Use a report icon here
                "Download Report",
                17,
                FontWeight.normal,
                Colors.white,
                const Color(0xFF133c0b),
                8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable button container
  Widget _buildButtonContainers(
    VoidCallback onPressed,
    String imageSource,
    String buttonLabel,
    double fontSize,
    FontWeight fontWeight,
    Color fontColor,
    Color buttonColor,
    double borderRadius,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 5),
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor.withOpacity(0.8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomIcon(
              imagePath: imageSource,
              size: 35,
            ),
            const SizedBox(width: 15),
            Text(
              buttonLabel,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: fontColor,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
