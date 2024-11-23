import 'package:flutter/material.dart';

class CropDetailsScreen extends StatelessWidget {
  final dynamic cropInfo;

  const CropDetailsScreen({super.key, required this.cropInfo});

  @override
  Widget build(BuildContext context) {
    var cropName = cropInfo['cropName'] ?? 'N/A';
    var cropImage = cropInfo['cropImage'] ?? '';
    var retailPrice = cropInfo['retailPrice'] ?? 0.0;
    var wholesalePrice = cropInfo['wholeSalePrice'] ?? 0.0;
    var landingPrice = cropInfo['landingPrice'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // To remove the shadow (optional)
        centerTitle: true,
        flexibleSpace: SizedBox(
          height: 80, // Set desired height for the image
          child: Image.asset(
            "lib/ui/assets/farm_price_icon_no_spaces.png",
            fit: BoxFit.contain, // Ensure the image fits well
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Crop Image
            cropImage.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12), // Adjust corner round
              child: Image.network(
                cropImage,
                height: 150,
                width: MediaQuery.sizeOf(context).width, // Set a fixed width
                fit: BoxFit.fitWidth, // Maintain aspect ratio
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(12), // Adjust corner round
              child: Image.asset(
                "lib/ui/assets/no_image.jpeg",
                height: 150, // Set a fixed height for placeholder
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),

            // Crop Name
            Center(
              child: Text(
                '$cropName',
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // Retail Price Container
            Container(
              width: double.infinity, // Full width of the screen
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Retail Price Text
                  const Text(
                    'Retail Price',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // Retail Price Value
                  Text(
                    '₱${retailPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Wholesale Price Container
            Container(
              width: double.infinity, // Full width of the screen
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Wholesale Price Text
                  const Text(
                    'Wholesale Price',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // Wholesale Price Value
                  Text(
                    '₱${wholesalePrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Landing Price Container
            Container(
              width: double.infinity, // Full width of the screen
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Landing Price Text
                  const Text(
                    'Landing Price',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // Landing Price Value
                  Text(
                    '₱${landingPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Footer Section - Source Information
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Data provided by Davao Food Terminal Complex (DFTC)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}