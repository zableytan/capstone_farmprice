import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _navigateToUniqueScreen(context, index, cropIds);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 123, 159, 76),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5.0,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  cardImages[index],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 20),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoricalDataScreen(cropIds: cropIds),
          ),
        );
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
}
