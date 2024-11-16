import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class UserCropReportCard extends StatelessWidget {
  // PARAMETERS NEEDED
  final dynamic cropReportInfo;

  // CONSTRUCTORS FOR CREATING NEW INSTANCE/OBJECT
  const UserCropReportCard({
    super.key,
    required this.cropReportInfo,
  });

  @override
  Widget build(BuildContext context) {
    var imageURL = cropReportInfo['cropReportImage'] as String?;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                  right: 10,
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: imageURL != null && imageURL.isNotEmpty
                        ? FadeInImage(
                      fit: BoxFit.cover,
                      placeholder:
                      const AssetImage("lib/ui/assets/no_image.jpeg"),
                      image: NetworkImage(imageURL),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "lib/ui/assets/no_image.jpeg",
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : const FadeInImage(
                      fit: BoxFit.cover,
                      placeholder:
                      AssetImage("lib/ui/assets/no_image.jpeg"),
                      image: AssetImage("lib/ui/assets/no_image.jpeg"),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Center(
                  child: AutoSizeText(
                    cropReportInfo['cropReportDescription'] ?? 'N/A',
                    style: const TextStyle(
                      color: Color(0xFF222227),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
