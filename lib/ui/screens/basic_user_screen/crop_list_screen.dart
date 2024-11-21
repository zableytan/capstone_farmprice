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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
          titleText: "Historical Data", // Changed from "Prices Today"
          fontColor: const Color(0xFF3C4D48),
          onLeadingPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search crops...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
<<<<<<< HEAD
<<<<<<< HEAD
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
=======
=======
>>>>>>> 36015d6 (Update project with latest changes)
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
<<<<<<< HEAD
>>>>>>> b25cef6b6450268ccac5668cf1f723682b9906b9
=======
>>>>>>> 36015d6 (Update project with latest changes)
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF133c0b)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
<<<<<<< HEAD
<<<<<<< HEAD
                  borderSide:
                      const BorderSide(color: Color(0xFF133c0b), width: 2),
=======
                  borderSide: const BorderSide(color: Color(0xFF133c0b), width: 2),
>>>>>>> b25cef6b6450268ccac5668cf1f723682b9906b9
=======
                  borderSide: const BorderSide(color: Color(0xFF133c0b), width: 2),
>>>>>>> 36015d6 (Update project with latest changes)
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
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

                  // Filter crops based on search query
                  if (_searchQuery.isNotEmpty) {
                    sortedCrops = sortedCrops.where((crop) {
                      String cropName = (crop['cropName'] ?? '').toLowerCase();
                      return cropName.contains(_searchQuery);
                    }).toList();
                  }

                  // Sort filtered crops by price
                  sortedCrops.sort((a, b) {
                    double aPrice = (a['retailPrice'] ?? 0).toDouble();
                    double bPrice = (b['retailPrice'] ?? 0).toDouble();
                    return bPrice.compareTo(aPrice); // Sort high to low
                  });

                  if (sortedCrops.isEmpty) {
                    return Center(
                      child: Text(
                        'No crops found matching "$_searchQuery"',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

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
<<<<<<< HEAD
<<<<<<< HEAD
                                cropIds:
                                    sortedCrops.map((crop) => crop.id).toList(),
                                initialIndex: index,
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
=======
=======
>>>>>>> 36015d6 (Update project with latest changes)
                                cropIds: sortedCrops.map((crop) => crop.id).toList(),
                                initialIndex: index,
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
<<<<<<< HEAD
>>>>>>> b25cef6b6450268ccac5668cf1f723682b9906b9
=======
>>>>>>> 36015d6 (Update project with latest changes)
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${cropInfo['cropName'] ?? 'Unknown Crop'}', // Added (kg)
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
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
          ),
        ],
      ),
    );
  }
}
