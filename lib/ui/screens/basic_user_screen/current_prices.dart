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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin_accounts')
            .doc('crops_available')
            .collection('crops')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // DISPLAY CUSTOM LOADING INDICATOR
            return const CustomLoadingIndicator();
          }
          // IF FETCHING DATA HAS ERROR EXECUTE THIS
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // CHECK IF THERE IS AVAILABLE DATA
          if (snapshot.data?.docs.isEmpty ?? true) {
            // DISPLAY THERE IS NO AVAILABLE DATA
            return const NoMarketAvailable(
              screenName: 'crops',
            );
          } else {
            // SORT DATA BY 'retailPrice' IN DESCENDING ORDER
            List<QueryDocumentSnapshot> sortedCrops = snapshot.data!.docs;
            sortedCrops.sort((a, b) {
              double aPrice = (a['retailPrice'] ?? 0).toDouble();
              double bPrice = (b['retailPrice'] ?? 0).toDouble();
              return bPrice.compareTo(aPrice); // Sort high to low
            });

            // DISPLAY SORTED DATA IN GRIDVIEW
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // NUMBER OF COLUMNS
                crossAxisSpacing: 5, // HORIZONTAL SPACE BETWEEN CARDS
                mainAxisSpacing: 5, // VERTICAL SPACE BETWEEN CARDS
                childAspectRatio: 4.5, // ASPECT RATIO OF EACH CARD
              ),
              itemCount: sortedCrops.length,
              itemBuilder: (context, index) {
                var cropInfo = sortedCrops[index];

                return UserCurrentPriceCard(
                  cropInfo: cropInfo,
                );
              },
            );
          }
        },
      ),
    );
  }
}
