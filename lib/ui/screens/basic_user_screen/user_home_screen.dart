import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/ui/screens/basic_user_screen/crop_list_screen.dart';
import 'package:myapp/ui/screens/basic_user_screen/crop_report.dart';
import 'package:myapp/ui/screens/basic_user_screen/current_prices.dart';
import 'package:myapp/ui/screens/basic_user_screen/historical_data.dart';
import 'package:myapp/ui/screens/basic_user_screen/market_trends.dart';
import 'package:myapp/ui/screens/basic_user_screen/markets.dart';
import 'package:myapp/ui/screens/basic_user_screen/price_changes.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator_v2.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final List<String> cardImages = [
    "lib/ui/assets/card_one_icon.png", // Current Prices
    "lib/ui/assets/card_five_icon.png", // Price Changes
    "lib/ui/assets/card_three_icon.png", // Market Trends
    "lib/ui/assets/card_two_icon.png", // Historical Data
    "lib/ui/assets/card_four_icon.png", // Crop Reports
    "lib/ui/assets/card_six_icon.png", // Markets
  ];

  final List<String> cardTexts = [
    'Current Prices',
    'Price Changes',
    'Market Trends',
    'Historical Data',
    'Crops Report',
    'Markets',
  ];

  final List<String> cardDescriptions = [
    'Real-time crop pricing',
    'Detailed price fluctuation analysis',
    'Seasonal and Trending Crop Rankings',
    'Track crop performance over time',
    'Latest News and Updates on Crops',
    'Explore agricultural market locations',
  ];

  final List<List<Color>> cardGradients = [
    [
      const Color.fromARGB(255, 73, 109, 26),
      const Color.fromARGB(255, 73, 109, 26),
    ],
    [
      const Color.fromARGB(255, 73, 109, 26),
      const Color.fromARGB(255, 73, 109, 26),
    ],
    [
      const Color.fromARGB(255, 73, 109, 26),
      const Color.fromARGB(255, 73, 109, 26),
    ],
    [
      const Color.fromARGB(255, 73, 109, 26),
      const Color.fromARGB(255, 73, 109, 26),
    ],
    [
      const Color.fromARGB(255, 73, 109, 26),
      const Color.fromARGB(255, 73, 109, 26),
    ],
    [
      const Color.fromARGB(255, 73, 109, 26),
      const Color.fromARGB(255, 73, 109, 26),
    ],
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _getCropIds() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .get();

      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error fetching crop IDs: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<String>>(
        future: _getCropIds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomLoadingIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching crop IDs"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No crops available"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () => _navigateToUniqueScreen(context, index),
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: cardGradients[index],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cardTexts[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        cardDescriptions[index],
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                        softWrap: true,
                                        maxLines: 2, // Ensures consistent height
                                        overflow: TextOverflow.ellipsis, // Handles overflow gracefully
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Image.asset(
                                cardImages[index],
                                width: 40,
                                height: 40,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void _navigateToUniqueScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CurrentPrices()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PriceChanges()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MarketTrends()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CropListScreen()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserCropReport()));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Markets()));
        break;
    }
  }
}
