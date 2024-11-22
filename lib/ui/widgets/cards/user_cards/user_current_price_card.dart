import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/ui/screens/basic_user_screen/crop_detail_screen.dart';

class UserCurrentPriceCard extends StatelessWidget {
  final dynamic cropInfo;

  const UserCurrentPriceCard({
    super.key,
    required this.cropInfo,
  });

  @override
  Widget build(BuildContext context) {
    var imageURL = cropInfo['cropImage'] as String?;
    var cropName = cropInfo['cropName'] ?? 'N/A';
    var retailPrice = cropInfo['retailPrice'] ?? 0.0;

    return GestureDetector(
      onTap: () {
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
              width: 1),
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF133c0b).withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 15),

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
                    placeholder: const AssetImage("lib/ui/assets/no_image.jpeg"),
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

              // Crop name and date in an Expanded widget to handle overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cropName,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis, // Add ellipsis when text overflows
                      maxLines: 1, // Limit to single line
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
              ),

              const SizedBox(width: 10), // Add some spacing before price

              // Price Info
              Text(
                '₱${retailPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),

              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }
}