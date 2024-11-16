import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/ui/screens/basic_user_screen/crop_report.dart';
import 'package:myapp/ui/screens/basic_user_screen/current_prices.dart';
import 'package:myapp/ui/screens/basic_user_screen/historical_data.dart';
import 'package:myapp/ui/screens/basic_user_screen/market_trends.dart';
import 'package:myapp/ui/screens/basic_user_screen/markets.dart';
import 'package:myapp/ui/screens/basic_user_screen/price_changes.dart';

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

  // Firestore instance to fetch crop data
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _getCropIds() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .get(); // Correct path to fetch crops
      print(
          "Fetched documents: ${snapshot.docs.map((doc) => doc.id).toList()}");

      List<String> cropIds = [];
      for (var doc in snapshot.docs) {
        cropIds.add(doc.id); // Assuming the document ID is the crop ID
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
      ),
      body: FutureBuilder<List<String>>(
        future: _getCropIds(), // Fetch crop IDs asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error fetching crop IDs"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No crops available"));
          } else {
            List<String> cropIds = snapshot.data!; // The list of crop IDs
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    "lib/ui/assets/farm_price_icon_no_spaces.png",
                    width: 200,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(context),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _navigateToUniqueScreen(context, index, cropIds);
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 123, 159, 76),
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  cardImages[index],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  cardTexts[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }
        },
      ),
    );
  }

  // Helper method to navigate to a unique screen based on the card index
  void _navigateToUniqueScreen(
      BuildContext context, int index, List<String> cropIds) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CurrentPrices()),
        );
        break;
      case 1:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HistoricalDataScreen(
        //         cropIds: cropIds), // Pass crop IDs to the next screen
        //   ),
        // );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MarketTrends()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserCropReport()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PriceChanges()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Markets()),
        );
        break;
    }
  }

  // Helper method to determine the number of columns based on screen width
  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return 2; // 2 columns for small screens (e.g., phones)
    } else if (width < 1200) {
      return 3; // 3 columns for medium screens (e.g., tablets)
    } else {
      return 4; // 4 columns for large screens (e.g., tablets in landscape or small desktops)
    }
  }
}
