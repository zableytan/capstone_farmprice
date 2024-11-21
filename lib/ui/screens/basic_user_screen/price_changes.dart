import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/cards/user_cards/user_price_changes_card.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator_v2.dart';
import 'package:myapp/ui/widgets/no_market_available.dart';

class PriceChanges extends StatefulWidget {
  const PriceChanges({super.key});

  @override
  State<PriceChanges> createState() => _PriceChangesState();
}

class _PriceChangesState extends State<PriceChanges> {
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
          titleText: "Price Changes",
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

                  // Filter and sort crops
                  sortedCrops = sortedCrops
                      .where((crop) => (crop['cropName'] ?? '')
<<<<<<< HEAD
                          .toString()
                          .toLowerCase()
                          .contains(_searchQuery))
=======
                      .toString()
                      .toLowerCase()
                      .contains(_searchQuery))
>>>>>>> 36015d6 (Update project with latest changes)
                      .toList();

                  sortedCrops.sort((a, b) {
                    double aPrice = (a['retailPrice'] ?? 0).toDouble();
                    double bPrice = (b['retailPrice'] ?? 0).toDouble();
                    return bPrice.compareTo(aPrice); // Sort high to low
                  });

                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
<<<<<<< HEAD
<<<<<<< HEAD
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
=======
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
>>>>>>> b25cef6b6450268ccac5668cf1f723682b9906b9
=======
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
>>>>>>> 36015d6 (Update project with latest changes)
                      crossAxisCount: 1, // NUMBER OF COLUMNS
                      crossAxisSpacing: 5, // HORIZONTAL SPACE BETWEEN CARDS
                      mainAxisSpacing: 5, // VERTICAL SPACE BETWEEN CARDS
                      childAspectRatio: 4.5, // ASPECT RATIO OF EACH CARD
                    ),
                    itemCount: sortedCrops.length,
                    itemBuilder: (context, index) {
                      var cropInfo = sortedCrops[index];

                      return UserPriceChangesCard(
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
