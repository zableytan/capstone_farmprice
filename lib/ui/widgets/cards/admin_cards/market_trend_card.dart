import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MarketTrendCard extends StatelessWidget {
  // PARAMETERS NEEDED
  final dynamic marketTrendInfo;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  // CONSTRUCTORS FOR CREATING NEW INSTANCE/OBJECT
  const MarketTrendCard({
    super.key,
    required this.marketTrendInfo,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    var imageURL = marketTrendInfo['cropImage'] as String?;

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
                  aspectRatio: 16 / 9,
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
                title: AutoSizeText(
                  marketTrendInfo['cropName'] ?? 'N/A',
                  style: const TextStyle(
                    color: Color(0xFF222227),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 15,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton(
                        onPressed: onUpdate,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF222227),
                            width: 1.5,
                          ),
                          minimumSize: const Size(35, 35),
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            color: Color(0xFF222227),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: onDelete,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: const Color(0xFF222227),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        minimumSize:
                        const Size(45, 35), // Adjusted for icon button
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
