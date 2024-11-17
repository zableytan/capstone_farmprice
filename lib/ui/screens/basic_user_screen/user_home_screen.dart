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
    "lib/ui/assets/card_one_icon.png",
    "lib/ui/assets/card_two_icon.png",
    "lib/ui/assets/card_three_icon.png",
    "lib/ui/assets/card_four_icon.png",
    "lib/ui/assets/card_five_icon.png",
    "lib/ui/assets/card_six_icon.png",
  ];

  final List<String> cardTexts = [
    'Current Prices',
    'Historical Data',
    'Market Trends',
    'Crops Report',
    'Price Changes',
    'Markets',
  ];

  // Updated gradient colors using green palette
  final List<List<Color>> cardGradients = [
    [
      Color.fromARGB(255, 123, 159, 76),
      Color.fromARGB(255, 143, 179, 96),
    ],
    [
      Color.fromARGB(255, 113, 149, 66),
      Color.fromARGB(255, 133, 169, 86),
    ],
    [
      Color.fromARGB(255, 103, 139, 56),
      Color.fromARGB(255, 123, 159, 76),
    ],
    [
      Color.fromARGB(255, 93, 129, 46),
      Color.fromARGB(255, 113, 149, 66),
    ],
    [
      Color.fromARGB(255, 83, 119, 36),
      Color.fromARGB(255, 103, 139, 56),
    ],
    [
      Color.fromARGB(255, 73, 109, 26),
      Color.fromARGB(255, 93, 129, 46),
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
      print("Fetched documents: ${snapshot.docs.map((doc) => doc.id).toList()}");

      List<String> cropIds = [];
      for (var doc in snapshot.docs) {
        cropIds.add(doc.id);
      }
      return cropIds;
    } catch (e) {
      print("Error fetching crop IDs: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background to make cards pop
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Color.fromARGB(255, 123, 159, 76),
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
            List<String> cropIds = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        _navigateToUniqueScreen(context, index, cropIds);
                      },
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
                        child: Stack(
                          children: [
                            Positioned(
                              left: 20,
                              top: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cardTexts[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to explore',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 20,
                              bottom: 20,
                              child: Image.asset(
                                cardImages[index],
                                width: 40,
                                height: 40,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
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

  void _navigateToUniqueScreen(BuildContext context, int index, List<String> cropIds) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CurrentPrices()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CropListScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MarketTrends()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserCropReport()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PriceChanges()));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Markets()));
        break;
    }
  }
}