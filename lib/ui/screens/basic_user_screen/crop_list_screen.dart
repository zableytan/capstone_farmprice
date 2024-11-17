import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/screens/basic_user_screen/historical_data.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator_v2.dart';
import 'package:myapp/ui/widgets/no_market_available.dart';

class CropListScreen extends StatefulWidget {
  const CropListScreen({super.key});

  @override
  State<CropListScreen> createState() => _CropListScreenState();
}

class _CropListScreenState extends State<CropListScreen> {
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
      body: StreamBuilder<QuerySnapshot>(
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

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 4.5,
              ),
              itemCount: sortedCrops.length,
              itemBuilder: (context, index) {
                var cropInfo = sortedCrops[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoricalDataScreen(
                          cropIds: sortedCrops
                              .map((crop) => crop.id)
                              .toList(), // Pass all crop IDs
                          initialIndex: index, // Start with the tapped crop
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: cropInfo['cropImage'] != null &&
                              cropInfo['cropImage'].isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                cropInfo['cropImage'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'lib/ui/assets/no_image.jpeg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                      title: Text(
                        cropInfo['cropName'] ?? 'Unknown Crop',
                        style: const TextStyle(fontSize: 11),
                      ),
                      subtitle: Text(
                        'Retail Price: ₱${cropInfo['retailPrice']?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
