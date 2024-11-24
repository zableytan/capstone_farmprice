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
        cropImage = cropDetails['cropImage'] ?? '';
      });

      Query query = FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropId)
          .collection('crop_price_history')
          .orderBy('date', descending: true);

      if (selectedYear.isNotEmpty) {
        query = query.where('date', isGreaterThanOrEqualTo: DateTime.parse('$selectedYear-01-01'));
      }
      if (selectedMonth.isNotEmpty) {
        query = query.where('date', isGreaterThanOrEqualTo: DateTime.parse('$selectedYear-$selectedMonth-01'));
      }
      if (selectedDay.isNotEmpty) {
        query = query.where('date', isGreaterThanOrEqualTo: DateTime.parse('$selectedYear-$selectedMonth-$selectedDay'));
      }

      final snapshot = await query.limit(5).get();

      final data = snapshot.docs.map((doc) {
        final date = (doc['date'] as Timestamp).toDate();
        final price = (doc['price'] as num).toDouble();
        return _PriceData(DateFormat('MM/dd/yyyy').format(date), price);
      }).toList();

      final now = DateTime.now();
      final past5Days = List.generate(5, (index) {
        final date = DateFormat('MM/dd/yyyy').format(now.subtract(Duration(days: index)));
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

  Widget _buildChart() {
    return SfCartesianChart(
      tooltipBehavior: _tooltip,
      primaryXAxis: CategoryAxis(),
      series: <CartesianSeries<_PriceData, String>>[
        LineSeries<_PriceData, String>(
          dataSource: priceData,
          xValueMapper: (_PriceData data, _) => data.date,
          yValueMapper: (_PriceData data, _) => data.price,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
    );
  }

  void _previousCrop() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        _loadCropData();
      }
    });
  }

  void _nextCrop() {
    setState(() {
      if (currentIndex < filteredCropIds.length - 1) {
        currentIndex++;
        _loadCropData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data for $cropName"),
        backgroundColor: const Color(0xFF133c0b).withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              cropImage.isNotEmpty
                  ? Image.network(cropImage, height: MediaQuery.of(context).size.height * 0.25)
                  : const SizedBox(height: 200),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedYear.isNotEmpty ? selectedYear : null,
                        hint: const Text('Year'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedYear = newValue!;
                            selectedMonth = '';
                            selectedDay = '';
                            _loadCropData();
                          });
                        },
                        items: ['2024', '2023', '2022', '2021', '2020']
                            .map((year) => DropdownMenuItem(
                          value: year,
                          child: Center(child: Text(year)),
                        ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedMonth.isNotEmpty ? selectedMonth : null,
                        hint: const Text('Month'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                            selectedDay = '';
                            _loadCropData();
                          });
                        },
                        items: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
                            .map((month) => DropdownMenuItem(
                          value: month,
                          child: Center(child: Text(month)),
                        ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedDay.isNotEmpty ? selectedDay : null,
                        hint: const Text('Day'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedDay = newValue!;
                            _loadCropData();
                          });
                        },
                        items: daysInMonth
                            .map((day) => DropdownMenuItem(
                          value: day,
                          child: Center(child: Text(day)),
                        ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : Column(
                children: [
                  _buildChart(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: currentIndex > 0 ? _previousCrop : null,
                      icon: const Icon(Icons.arrow_back, color: Colors.white), // Arrow color set to white
                      label: const Text(
                        'Previous',
                        style: TextStyle(color: Colors.white), // Text color set to white
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentIndex > 0 ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: currentIndex < filteredCropIds.length - 1 ? _nextCrop : null,
                      icon: const Icon(Icons.arrow_forward, color: Colors.white), // Arrow color set to white
                      label: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white), // Text color set to white
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentIndex < filteredCropIds.length - 1 ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Data provided by Davao Food Terminal Complex (DFTC)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
            ],
          ),
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
