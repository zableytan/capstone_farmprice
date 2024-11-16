// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:myapp/models/price_history.dart'; // Import your PriceHistory model
//
// class HistoricalDataScreen extends StatefulWidget {
//   final List<String> cropIds; // List of crop IDs
//   final int initialCropIndex;
//
//   const HistoricalDataScreen({
//     super.key,
//     required this.cropIds,
//     this.initialCropIndex = 0,
//   });
//
//   @override
//   _HistoricalDataScreenState createState() => _HistoricalDataScreenState();
// }
//
// class _HistoricalDataScreenState extends State<HistoricalDataScreen> {
//   int currentCropIndex = 0;
//   List<PriceHistory> priceHistory = [];
//
//   @override
//   void initState() {
//     super.initState();
//     currentCropIndex = widget.initialCropIndex;
//     fetchData();
//   }
//
//   // Fetch price history for the current crop
//   void fetchData() async {
//     final cropId = widget.cropIds[currentCropIndex];
//     final history = await fetchPriceHistory(cropId);
//     setState(() {
//       priceHistory = history;
//     });
//   }
//
//   // Fetch historical prices (last 5 days) from Firestore
//   Future<List<PriceHistory>> fetchPriceHistory(String cropId) async {
//     List<PriceHistory> priceHistory = [];
//
//     final cropPricesRef = FirebaseFirestore.instance
//         .collection('admin_accounts')
//         .doc('crops_available')
//         .collection('crops')
//         .doc(cropId)
//         .collection('crop_price_history');
//
//     final snapshot =
//     await cropPricesRef.orderBy('date', descending: true).limit(5).get();
//
//     for (var doc in snapshot.docs) {
//       final data = doc.data();
//       DateTime date = (data['date'] as Timestamp).toDate();
//       double price = data['price'].toDouble();
//
//       priceHistory.add(PriceHistory(date: date, price: price));
//     }
//
//     return priceHistory;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Historical Data: ${widget.cropIds[currentCropIndex]}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Price history chart
//             priceHistory.isEmpty
//                 ? const CircularProgressIndicator()
//                 : Expanded(
//               child: LineChart(
//                 LineChartData(
//                   gridData: FlGridData(show: true),
//                   titlesData: FlTitlesData(show: true),
//                   borderData: FlBorderData(show: true),
//                   minX: priceHistory.first.date.millisecondsSinceEpoch
//                       .toDouble(),
//                   maxX: priceHistory.last.date.millisecondsSinceEpoch
//                       .toDouble(),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: priceHistory
//                           .map((e) => FlSpot(
//                         e.date.millisecondsSinceEpoch.toDouble(),
//                         e.price,
//                       ))
//                           .toList(),
//                       isCurved: true,
//                       colors: [
//                         Colors.blue
//                       ], // Correct usage  // Removed unnecessary BarChartBarData
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Navigation buttons for next and previous crop
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () {
//                     setState(() {
//                       if (currentCropIndex > 0) {
//                         currentCropIndex--;
//                         fetchData();
//                       }
//                     });
//                   },
//                 ),
//                 Text(
//                   'Crop ${currentCropIndex + 1} of ${widget.cropIds.length}',
//                   style: const TextStyle(fontSize: 18),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.arrow_forward),
//                   onPressed: () {
//                     setState(() {
//                       if (currentCropIndex < widget.cropIds.length - 1) {
//                         currentCropIndex++;
//                         fetchData();
//                       }
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// //