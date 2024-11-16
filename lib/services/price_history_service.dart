import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/price_history.dart';

Future<List<PriceHistory>> fetchPriceHistory(String cropId) async {
  List<PriceHistory> priceHistory = [];

  // Get the crop's price history from Firestore
  final cropPricesRef = FirebaseFirestore.instance
      .collection('admin_accounts')
      .doc('crops_available')
      .collection('crops')
      .doc(cropId)
      .collection('crop_price_history');

  final snapshot = await cropPricesRef
      .orderBy('date', descending: true) // Sort by date
      .limit(5) // Limit to the last 5 entries
      .get();

  for (var doc in snapshot.docs) {
    final data = doc.data();
    DateTime date = (data['date'] as Timestamp).toDate();
    double price = data['price'].toDouble();

    priceHistory.add(PriceHistory(date: date, price: price));
  }

  return priceHistory;
}
