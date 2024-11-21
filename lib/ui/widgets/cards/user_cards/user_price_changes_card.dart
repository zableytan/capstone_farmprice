import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/ui/screens/basic_user_screen/crop_detail_screen.dart';

class UserPriceChangesCard extends StatelessWidget {
  // PARAMETERS NEEDED
  final dynamic cropInfo;

  // CONSTRUCTOR FOR CREATING NEW INSTANCE/OBJECT
  const UserPriceChangesCard({
    super.key,
    required this.cropInfo,
  });

  @override
  Widget build(BuildContext context) {
    var imageURL = cropInfo['cropImage'] as String?;
    var cropName = cropInfo['cropName'] ?? 'N/A';
    var retailPrice = cropInfo['retailPrice'] ?? 0.0;
    var oldRetailPrice = cropInfo['oldRetailPrice'] ?? 0.0;

    // Calculate price difference
    double priceDifference = retailPrice - oldRetailPrice;
    bool isPriceUp = priceDifference > 0;

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
          color: const Color(0xFF133c0b).withOpacity(0.3),
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
              // Circular Image
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
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    cropName,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13, // You can set a max font size here
                    ),
                    maxLines: 1, // Ensure the text stays on one line
                    minFontSize: 10, // Minimum font size when text is too long
                  ),
                  Text(
                    DateFormat('MM/dd/yyyy').format(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 12, 134, 16),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Price Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Retail Price
                  Text(
                    '₱${retailPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),

                  // Price Difference with Arrow
                  Row(
                    mainAxisSize: MainAxisSize
                        .min, // Prevent overflow by making row size fit content
                    children: [
                      Icon(
                        isPriceUp ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isPriceUp ? Colors.green[700] : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '₱${priceDifference.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isPriceUp ? Colors.green[700] : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
