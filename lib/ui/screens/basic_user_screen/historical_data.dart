import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator_v2.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class HistoricalDataScreen extends StatefulWidget {
  final List<String> cropIds;

  const HistoricalDataScreen({Key? key, required this.cropIds})
      : super(key: key);

  @override
  _HistoricalDataScreenState createState() => _HistoricalDataScreenState();
}

class _HistoricalDataScreenState extends State<HistoricalDataScreen> {
  int currentIndex = 0; // Track the selected crop
  List<_PriceData> priceData = []; // Store historical price data
  bool isLoading = true; // Loading indicator
  late TooltipBehavior _tooltip;
  String cropName = ''; // Variable to store crop name
  String cropImage = ''; // Variable to store crop image URL

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
    _loadCropData(); // Load data for the initial crop
  }

  Future<void> _loadCropData() async {
    setState(() => isLoading = true);

    try {
      final cropId = widget.cropIds[currentIndex];

      // Fetch crop details (name and image)
      final cropDoc = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropId)
          .get();

      if (cropDoc.exists) {
        setState(() {
          cropName = cropDoc['cropName']; // Store the crop name
          cropImage = cropDoc['cropImage']; // Store the crop image URL
        });
        // Optionally, you can use these details in the UI or store them for later use
        print('Crop Name: $cropName');
        print('Crop Image: $cropImage');
      }

      // Fetch historical price data
      final snapshot = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropId)
          .collection('crop_price_history')
          .orderBy('date', descending: true)
          .limit(5) // Fetch last 5 days
          .get();

      final List<_PriceData> data = snapshot.docs.map((doc) {
        final date = (doc['date'] as Timestamp).toDate();
        final price = doc['price'] as double;
        return _PriceData(DateFormat('MM/dd/yyyy').format(date), price);
      }).toList();

      // Ensure we have data for the past 5 days, if not, insert 0 or previous price
      final now = DateTime.now();
      final past5Days = List.generate(5, (index) {
        final date = DateFormat('MM/dd/yyyy')
            .format(now.subtract(Duration(days: index)));
        final priceDataForDate = data.firstWhere(
              (item) => item.date == date,
          orElse: () => _PriceData(date, 0), // If no data, default price 0
        );
        return priceDataForDate;
      }).reversed.toList(); // Reverse to show oldest first

      setState(() {
        priceData = past5Days;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching historical data: $e');
      setState(() => isLoading = false);
    }
  }

  // Navigate to the next crop
  void _nextCrop() {
    if (currentIndex < widget.cropIds.length - 1) {
      setState(() => currentIndex++);
      _loadCropData();
    }
  }

  // Navigate to the previous crop
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
          titleText: "Historical Data",
          fontColor: const Color(0xFF3C4D48),
          onLeadingPressed: () {
            Navigator.pop(context); // Safely pops to the previous screen
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CustomLoadingIndicator())
          : Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 35,
              left: 35,
              right: 35,
              bottom: 0,
            ),
            child: cropImage.isNotEmpty
                ? ClipRRect(
              borderRadius:
              BorderRadius.circular(12), // Adjust corner round
              child: Image.network(
                cropImage,
                height: 120,
                width: MediaQuery.sizeOf(context)
                    .width, // Set a fixed width
                fit: BoxFit.fitWidth, // Maintain aspect ratio
              ),
            )
                : ClipRRect(
              borderRadius:
              BorderRadius.circular(12), // Adjust corner round
              child: Image.asset(
                "lib/ui/assets/no_image.jpeg",
                height: 150, // Set a fixed height for placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(
            height: 5,
          ),
          // Crop Name
          Center(
            child: Text(
              cropName,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),

          // Chart displaying historical price data
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(text: 'Date'),
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Price'),
                minimum: 0,
                interval: 10,
              ),
              legend: const Legend(isVisible: true),
              tooltipBehavior: _tooltip,
              series: <CartesianSeries<_PriceData, String>>[
                ColumnSeries<_PriceData, String>(
                  dataSource: priceData,
                  xValueMapper: (_PriceData data, _) => data.date,
                  yValueMapper: (_PriceData data, _) => data.price,
                  name: 'Price',
                  dataLabelSettings:
                  const DataLabelSettings(isVisible: true),
                  color: const Color.fromARGB(255, 53, 117, 41)
                      .withOpacity(0.5),
                ),
              ],
            ),
          ),
          // Navigation buttons
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Center(
              // Center the row
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Center the buttons horizontally
                children: [
                  ElevatedButton(
                    onPressed: currentIndex > 0 ? _previousCrop : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color.fromARGB(255, 53, 117, 41)
                          .withOpacity(0.5), // Set button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Set corner radius (curves the corners)
                      ),
                    ),
                    child: const Text(
                      'Previous Crop',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 10), // Add some space between the buttons
                  ElevatedButton(
                    onPressed: currentIndex < widget.cropIds.length - 1
                        ? _nextCrop
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color.fromARGB(255, 53, 117, 41)
                          .withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Set corner radius (curves the corners)
                      ),
                    ),
                    child: const Text(
                      'Next Crop',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Model class for chart data
class _PriceData {
  final String date;
  final double price;

  _PriceData(this.date, this.price);
}
