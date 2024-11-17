import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/cards/user_cards/user_current_price_card.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator_v2.dart';
import 'package:myapp/ui/widgets/no_market_available.dart';

class CurrentPrices extends StatefulWidget {
  const CurrentPrices({super.key});

  @override
  State<CurrentPrices> createState() => _CurrentPricesState();
}

class _CurrentPricesState extends State<CurrentPrices> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(
          backgroundColor: const Color(0xFF133c0b).withOpacity(0.3),
          titleText: "Prices Today",
          fontColor: const Color(0xFF3C4D48),
          onLeadingPressed: () {
            Navigator.pop(context); // Safely pops to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search crops...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('admin_accounts')
                  .doc('crops_available')
                  .collection('crops')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoadingIndicator();
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.data?.docs.isEmpty ?? true) {
                  return const NoMarketAvailable(
                    screenName: 'crops',
                  );
                } else {
                  List<QueryDocumentSnapshot> sortedCrops = snapshot.data!.docs;
                  sortedCrops.sort((a, b) {
                    double aPrice = (a['retailPrice'] ?? 0).toDouble();
                    double bPrice = (b['retailPrice'] ?? 0).toDouble();
                    return bPrice.compareTo(aPrice); // Sort high to low
                  });

                  // Filter the sorted crops based on search query
                  List<QueryDocumentSnapshot> filteredCrops = sortedCrops
                      .where((crop) => (crop['cropName'] ?? '')
                          .toString()
                          .toLowerCase()
                          .contains(_searchQuery))
                      .toList();

                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 4.5,
                    ),
                    itemCount: filteredCrops.length,
                    itemBuilder: (context, index) {
                      var cropInfo = filteredCrops[index];

                      return UserCurrentPriceCard(
                        cropInfo: cropInfo,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
