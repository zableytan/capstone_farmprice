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
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search crops...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF133c0b)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          // Crops List
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
                  return const Center(
                    child: Text(
                      'Failed to load data. Please try again later.',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                final List<QueryDocumentSnapshot> crops = snapshot.data?.docs ?? [];

                // Filter and sort crops
                final List<QueryDocumentSnapshot> filteredCrops = _filterAndSortCrops(crops);

                // Display feedback for empty lists
                if (filteredCrops.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No crops found for "$_searchQuery"'
                              : 'No crops available at the moment.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
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
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Filters and sorts crops based on search query and price
  List<QueryDocumentSnapshot> _filterAndSortCrops(List<QueryDocumentSnapshot> crops) {
    List<QueryDocumentSnapshot> sortedCrops = crops;

    // Sort by descending retail price
    sortedCrops.sort((a, b) {
      double aPrice = (a['retailPrice'] ?? 0).toDouble();
      double bPrice = (b['retailPrice'] ?? 0).toDouble();
      return bPrice.compareTo(aPrice);
    });

    // Filter based on search query
    if (_searchQuery.isNotEmpty) {
      sortedCrops = sortedCrops.where((crop) {
        final cropName = (crop['cropName'] ?? '').toString().toLowerCase();
        return cropName.contains(_searchQuery);
      }).toList();
    }

    return sortedCrops;
  }
}