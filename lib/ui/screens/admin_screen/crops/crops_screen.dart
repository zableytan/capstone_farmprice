import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_service.dart';
import 'package:myapp/ui/screens/admin_screen/crops/add_crops.dart';
import 'package:myapp/ui/screens/admin_screen/crops/update_crop.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/cards/admin_cards/crop_card.dart';
import 'package:myapp/ui/widgets/custom_floating_action_button.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator_v2.dart';
import 'package:myapp/ui/widgets/modals/custom_modals.dart';
import 'package:myapp/ui/widgets/navigation/custom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/ui/widgets/no_market_available.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  String _searchQuery = ""; // Variable to hold the search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(
          backgroundColor: const Color(0xFF133c0b).withOpacity(0.3),
          titleText: "Crops",
          fontColor: const Color(0xFF3C4D48),
          onLeadingPressed: () {
            Navigator.pop(context); // Safely pops to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase(); // Update search query
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search crops...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // STREAM BUILDER FOR DATA
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
                  return const NoMarketAvailable(screenName: 'crops');
                }

                // FILTER CROPS BASED ON SEARCH QUERY
                List<QueryDocumentSnapshot> filteredCrops = snapshot.data!.docs
                    .where((doc) {
                  String cropName = (doc['cropName'] ?? '').toString().toLowerCase();
                  return cropName.contains(_searchQuery);
                })
                    .toList();

                if (filteredCrops.isEmpty) {
                  return const NoMarketAvailable(screenName: 'filtered crops');
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // NUMBER OF COLUMNS
                    crossAxisSpacing: 10, // HORIZONTAL SPACE BETWEEN CARDS
                    mainAxisSpacing: 10, // VERTICAL SPACE BETWEEN CARDS
                    childAspectRatio: 0.8, // ASPECT RATIO OF EACH CARD
                  ),
                  itemCount: filteredCrops.length,
                  itemBuilder: (context, index) {
                    var cropInfo = filteredCrops[index];

                    return CropCard(
                      cropInfo: cropInfo,
                      onUpdate: () {
                        String cropID = cropInfo.id;
                        navigateWithSlideFromRight(
                          context,
                          UpdateCrop(
                            cropID: cropID,
                          ),
                          0.0,
                          1.0,
                        );
                      },
                      onDelete: () async {
                        showDeleteWarning(
                          context,
                          'Are you sure you want to delete this crop?',
                          'Delete',
                              (cropID) => FirebaseService.deleteCrop(
                              context, cropID: cropID),
                          cropInfo.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        textLabel: "Add Crops",
        onPressed: () {
          navigateWithSlideFromRight(
            context,
            const AddCrops(),
            1.0,
            0.0,
          );
        },
      ),
    );
  }
}
