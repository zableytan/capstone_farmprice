import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator_v2.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HistoricalDataScreen extends StatefulWidget {
  final List<String> cropIds;
  final int initialIndex;

  const HistoricalDataScreen({
    super.key,
    required this.cropIds,
    this.initialIndex = 0,
  });

  @override
  _HistoricalDataScreenState createState() => _HistoricalDataScreenState();
}

class _HistoricalDataScreenState extends State<HistoricalDataScreen> {
  int currentIndex = 0;
  List<_PriceData> priceData = [];
  bool isLoading = true;
  late TooltipBehavior _tooltip;
  String cropName = '';
  String cropImage = '';
  String errorMessage = '';

  // New variables for search functionality
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allCrops = [];
  List<String> filteredCropIds = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
    currentIndex = widget.initialIndex;
    filteredCropIds = List.from(widget.cropIds);
    _loadAllCrops();
    _loadCropData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // New method to load all crops initially
  Future<void> _loadAllCrops() async {
    try {
      final cropsSnapshot = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .get();

      setState(() {
        allCrops = cropsSnapshot.docs
            .map((doc) => {
          'id': doc.id,
          'cropName': doc.data()['cropName'] ?? 'Unknown Crop',
        })
            .toList();
      });
    } catch (e) {
      print('Error loading all crops: $e');
    }
  }

  // New method to handle search
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCropIds = List.from(widget.cropIds);
        isSearching = false;
      } else {
        isSearching = true;
        filteredCropIds = allCrops
            .where((crop) =>
        crop['cropName']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()) &&
            widget.cropIds.contains(crop['id']))
            .map((crop) => crop['id'] as String)
            .toList();
      }
      currentIndex = 0;
      if (filteredCropIds.isNotEmpty) {
        _loadCropData();
      }
    });
  }

  Future<void> _loadCropData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final cropId = filteredCropIds[currentIndex];

      final cropDoc = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropId)
          .get();

      if (!cropDoc.exists) throw Exception('Crop details not found.');

      final cropDetails = cropDoc.data()!;
      setState(() {
        cropName = cropDetails['cropName'] ?? 'Unknown Crop';
        cropImage = cropDetails['cropImage'] ?? '';
      });

      final snapshot = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropId)
          .collection('crop_price_history')
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      final data = snapshot.docs.map((doc) {
        final date = (doc['date'] as Timestamp).toDate();
        final price = (doc['price'] as num).toDouble();
        return _PriceData(DateFormat('MM/dd/yyyy').format(date), price);
      }).toList();

      final now = DateTime.now();
      final past5Days = List.generate(5, (index) {
        final date =
        DateFormat('MM/dd/yyyy').format(now.subtract(Duration(days: index)));
        return data.firstWhere(
              (item) => item.date == date,
          orElse: () => _PriceData(date, 0),
        );
      }).reversed.toList();

      setState(() {
        priceData = past5Days;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to fetch crop data: $e';
      });
    }
  }

  void _nextCrop() {
    if (currentIndex < filteredCropIds.length - 1) {
      setState(() => currentIndex++);
      _loadCropData();
    }
  }

  void _previousCrop() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _loadCropData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(
          backgroundColor: const Color(0xFF133c0b).withOpacity(0.3),
          titleText:
          cropName.isNotEmpty ? "Data for $cropName" : "Historical Data",
          fontColor: const Color(0xFF3C4D48),
          onLeadingPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search crops...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF133c0b)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF133c0b), width: 2),
                ),
              ),
              onChanged: _handleSearch,
            ),
          ),

          // Show "No results found" when search yields no results
          if (isSearching && filteredCropIds.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No crops found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: isLoading
                  ? const Center(child: CustomLoadingIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(35),
                    child: cropImage.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        cropImage,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                        : Image.asset(
                      "lib/ui/assets/no_image.jpeg",
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    cropName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SfCartesianChart(
                      primaryXAxis: const CategoryAxis(
                          title: AxisTitle(text: 'Date')),
                      primaryYAxis: NumericAxis(
                        title: const AxisTitle(text: 'Price'),
                        labelFormat: '₱{value}',
                      ),
                      tooltipBehavior: _tooltip,
                      series: [
                        ColumnSeries<_PriceData, String>(
                          dataSource: priceData,
                          xValueMapper: (data, _) => data.date,
                          yValueMapper: (data, _) => data.price,
                          dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:
                          currentIndex > 0 ? _previousCrop : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF133c0b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Previous',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: currentIndex <
                              filteredCropIds.length - 1
                              ? _nextCrop
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF133c0b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceData {
  final String date;
  final double price;

  _PriceData(this.date, this.price);
}