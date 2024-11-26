import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  State<HistoricalDataScreen> createState() => _HistoricalDataScreenState();
}

class _HistoricalDataScreenState extends State<HistoricalDataScreen> {
  int currentIndex = 0;
  List<_PriceData> priceData = [];
  bool isLoading = true;
  late TooltipBehavior _tooltip;
  String cropName = '';
  String cropImage = '';
  String errorMessage = '';

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allCrops = [];
  List<String> filteredCropIds = [];
  bool isSearching = false;

  // Filters
  String selectedYear = '';
  String selectedMonth = '';
  String selectedDay = '';
  List<String> daysInMonth = List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
    currentIndex = widget.initialIndex;
    filteredCropIds = List.from(widget.cropIds);
    _loadAllCrops();
    _loadCropData();
  }

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
          'cropImage': doc.data()['cropImage'] ?? '',
        })
            .toList();
      });
    } catch (e) {
      debugPrint('Error loading crops: $e');
    }
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
        cropImage = cropDetails['cropImage'] ?? ''; // Assign cropImage from Firestore
      });

      Query query = FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropId)
          .collection('crop_price_history')
          .orderBy('date', descending: true);

      // Build date range filter
      DateTime? startDate;
      if (selectedYear.isNotEmpty) {
        if (selectedMonth.isNotEmpty) {
          if (selectedDay.isNotEmpty) {
            // Specific day selected
            startDate = DateTime.parse('$selectedYear-$selectedMonth-$selectedDay');
          } else {
            // Specific month selected
            startDate = DateTime.parse('$selectedYear-$selectedMonth-01');
          }
        } else {
          // Specific year selected
          startDate = DateTime.parse('$selectedYear-01-01');
        }

        // Add where clause for date filtering
        query = query.where('date', isGreaterThanOrEqualTo: startDate);
      }

      // Remove limit to get all data
      final snapshot = await query.get();

      final data = snapshot.docs.map((doc) {
        final date = (doc['date'] as Timestamp).toDate();
        final price = (doc['price'] as num).toDouble();
        return _PriceData(DateFormat('MM/dd/yyyy').format(date), price);
      }).toList()
      // Sort data chronologically
        ..sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        priceData = data; // Use all retrieved data
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to fetch crop data: $e';
      });
    }
  }

  // Add filter method
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Filter Data',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Year Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedYear.isNotEmpty ? selectedYear : null,
                    items: ['2024', '2023', '2022', '2021', '2020']
                        .map((year) => DropdownMenuItem(
                      value: year,
                      child: Text(year),
                    ))
                        .toList(),
                    onChanged: (newValue) {
                      setModalState(() {
                        selectedYear = newValue!;
                        selectedMonth = '';
                        selectedDay = '';
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  // Month Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Month',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedMonth.isNotEmpty ? selectedMonth : null,
                    items: [
                      '01', '02', '03', '04', '05', '06',
                      '07', '08', '09', '10', '11', '12'
                    ]
                        .map((month) => DropdownMenuItem(
                      value: month,
                      child: Text(month),
                    ))
                        .toList(),
                    onChanged: selectedYear.isNotEmpty
                        ? (newValue) {
                      setModalState(() {
                        selectedMonth = newValue!;
                        selectedDay = '';
                      });
                    }
                        : null,
                  ),
                  const SizedBox(height: 15),
                  // Day Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Day',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedDay.isNotEmpty ? selectedDay : null,
                    items: daysInMonth
                        .map((day) => DropdownMenuItem(
                      value: day,
                      child: Text(day),
                    ))
                        .toList(),
                    onChanged: (selectedMonth.isNotEmpty && selectedYear.isNotEmpty)
                        ? (newValue) {
                      setModalState(() {
                        selectedDay = newValue!;
                      });
                    }
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Reset filters
                          setModalState(() {
                            selectedYear = '';
                            selectedMonth = '';
                            selectedDay = '';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                        child: const Text('Reset'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Apply filters
                          Navigator.pop(context);
                          _loadCropData();
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChart() {
    return SfCartesianChart(
      tooltipBehavior: _tooltip,
      primaryXAxis: const CategoryAxis(
        labelRotation: 45, // Rotate labels if many dates
        interval: 1, // Show all labels
        title: AxisTitle(
          text: 'Date',
          textStyle: TextStyle(color: Colors.green), // Set color for X-axis title
        ),
      ),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(
          text: 'Price (PHP)',
          textStyle: TextStyle(color: Colors.green), // Set color for Y-axis title
        ),
      ),
      series: <CartesianSeries<_PriceData, String>>[
        LineSeries<_PriceData, String>(
          dataSource: priceData,
          xValueMapper: (_PriceData data, _) => data.date,
          yValueMapper: (_PriceData data, _) => data.price,
          name: 'Price',
          markerSettings: const MarkerSettings(isVisible: true),
          color: Colors.blue,
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cropName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Crop info and price
            Card(
              elevation: 5,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: cropImage.isNotEmpty
                    ? Image.network(cropImage, width: 50, height: 50)
                    : const Icon(Icons.image_not_supported),
                title: Text(cropName, style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text('Last price: ${priceData.isNotEmpty ? priceData.last.price : 'N/A'} PHP'),
              ),
            ),
            const SizedBox(height: 20),
            // Filter button
            ElevatedButton.icon(
              onPressed: _showFilterBottomSheet,
              icon: const Icon(Icons.filter_list),
              label: const Text('Filter Data'),
            ),
            const SizedBox(height: 20),
            // Error message if any
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            // Chart display
            _buildChart(),
            const SizedBox(height: 20),
            // Add text at the bottom center
            const Center(
              child: Text(
                'Data from Davao Food Terminal Complex (DFTC)',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceData {
  _PriceData(this.date, this.price);

  final String date;
  final double price;
}
