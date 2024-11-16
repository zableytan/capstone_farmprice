import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/screens/basic_user_screen/crop_detail_screen.dart';

class UserMarketTrendsCard extends StatelessWidget {
  // PARAMETERS NEEDED
  final dynamic cropInfo;
  final int index;

  // CONSTRUCTOR FOR CREATING NEW INSTANCE/OBJECT
  const UserMarketTrendsCard({
    super.key,
    required this.cropInfo,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var imageURL = cropInfo['cropImage'] as String?;

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
            crossAxisAlignment:
            CrossAxisAlignment.center, // Align children vertically
            children: <Widget>[
              const SizedBox(width: 20),
              // First Column: Counter
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    '#${index + 1}', // Display the counter starting from 1
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color(0xFF222227),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 50),

              // Second Column: Circular Image
              SizedBox(
                width: 50,
                height: 50,
                child: ClipOval(
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

              const SizedBox(width: 50),

              // Third Column: Crop Name
              Expanded(
                child: AutoSizeText(
                  cropInfo['cropName'] ?? 'N/A',
                  style: const TextStyle(
                    color: Color(0xFF222227),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
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
