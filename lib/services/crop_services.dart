import 'package:cloud_firestore/cloud_firestore.dart';

class CropService {
  // Fetch the latest price for each crop
  static Future<List<Map<String, dynamic>>> fetchLatestCropsWithPrice() async {
    try {
      final QuerySnapshot cropSnapshot = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .get();

      List<Map<String, dynamic>> cropsWithLatestPrices = [];

      for (var cropDoc in cropSnapshot.docs) {
        final String cropID = cropDoc.id;
        final Map<String, dynamic> cropData = cropDoc.data() as Map<String, dynamic>;

        final QuerySnapshot priceHistorySnapshot = await FirebaseFirestore.instance
            .collection('admin_accounts')
            .doc('crops_available')
            .collection('crops')
            .doc(cropID)
            .collection('crop_price_history')
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        if (priceHistorySnapshot.docs.isNotEmpty) {
          final Map<String, dynamic> latestPriceData =
          priceHistorySnapshot.docs.first.data() as Map<String, dynamic>;

          cropsWithLatestPrices.add({
            'cropName': cropData['cropName'],
            'retailPrice': cropData['retailPrice'],
            'wholeSalePrice': cropData['wholeSalePrice'],
            'landingPrice': cropData['landingPrice'],
            'latestDate': latestPriceData['date'],
            'latestPrice': latestPriceData['price'],
          });
        }
      }

      return cropsWithLatestPrices;
    } catch (e) {
      print('Error fetching crops with latest prices: $e');
      return [];
    }
  }
}
