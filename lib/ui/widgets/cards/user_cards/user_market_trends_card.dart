import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/screens/basic_user_screen/crop_detail_screen.dart';

class UserMarketTrendsCard extends StatelessWidget {
  // PARAMETERS NEEDED
  final dynamic cropInfo;

  // CONSTRUCTOR FOR CREATING NEW INSTANCE/OBJECT
  const UserMarketTrendsCard({
    super.key,
    required this.cropInfo,
  });

  @override
  Widget build(BuildContext context) {
    var imageURL = cropInfo['cropImage'] as String?;
    var ranking = cropInfo['ranking'] ?? 0; // Get ranking from crop info

    return GestureDetector(
      onTap: () {
        // Navigate to the CropDetailsScreen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropDetailsScreen(
              cropInfo: cropInfo,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey,
              width: 1), // Single border for the entire card
          borderRadius: BorderRadius.circular(10),
          color:
          const Color(0xFF133c0b).withOpacity(0.3), // Light grey background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color (light gray)
              spreadRadius: 2, // How much the shadow spreads
              blurRadius: 5, // Blur effect for a softer shadow
              offset:
              const Offset(0, 3), // Shadow position (horizontal, vertical)
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(
            vertical: 5, horizontal: 10), // Card spacing
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Align children vertically
            children: <Widget>[
              // Ranking on the left side
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF3C4D48), // Dark background for ranking
                  borderRadius: BorderRadius.circular(5),
                ),
                child: AutoSizeText(
                  '$ranking', // Display the ranking
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                ),
              ),
              const SizedBox(width: 20), // Space between ranking and image

              // Crop Image
              SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Adjust this value for rounding
                  child: imageURL != null && imageURL.isNotEmpty
                      ? FadeInImage(
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder:
                    const AssetImage("lib/ui/assets/no_image.jpeg"),
                    image: NetworkImage(imageURL),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "lib/ui/assets/no_image.jpeg",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    "lib/ui/assets/no_image.jpeg",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 20), // Space between image and crop name

              // Crop Name
              Expanded(
                child: AutoSizeText(
                  cropInfo['cropName'] ?? 'N/A',
                  style: const TextStyle(
                    color: Color(0xFF222227),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 12,
                ),
              ),

              const SizedBox(width: 20), // Space between crop name and price

              // Crop Price
              Expanded(
                child: AutoSizeText(
                  "₱ ${double.tryParse(cropInfo['retailPrice'].toString())?.toStringAsFixed(2) ?? '0.00'}",
                  style: const TextStyle(
                    color: Color(0xFF222227),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
