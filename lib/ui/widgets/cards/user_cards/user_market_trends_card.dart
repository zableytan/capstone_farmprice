import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/screens/basic_user_screen/crop_detail_screen.dart';

class RankingBox extends StatelessWidget {
  final int ranking;

  const RankingBox({
    super.key,
    required this.ranking,
  });

  @override
  Widget build(BuildContext context) {
    final rankColor = _getRankColor(ranking);
    final textColor = _getTextColor(ranking);
    final crownIcon = _getCrownIcon(ranking);

    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: rankColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ranking <= 3) ...[
            Icon(
              crownIcon,
              color: textColor,
              size: 16,
            ),
            const SizedBox(height: 2),
          ],
          AutoSizeText(
            '#$ranking',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            minFontSize: 12,
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) {
      return const Color(0xFFFFD700).withOpacity(0.85); // Gold
    } else if (rank == 2) {
      return const Color(0xFFC0C0C0).withOpacity(0.85); // Silver
    } else if (rank == 3) {
      return const Color(0xFFCD7F32).withOpacity(0.85); // Bronze
    } else if (rank <= 5) {
      return const Color(0xFFC0C0C0).withOpacity(0.5); // Light Silver
    } else {
      return const Color(0xFFC0C0C0).withOpacity(0.5); // Light Bronze
    }
  }

  Color _getTextColor(int rank) {
    if (rank == 1) {
      return Colors.brown.shade900;
    } else if (rank == 2) {
      return Colors.grey.shade900;
    } else if (rank == 3) {
      return Colors.brown.shade800;
    } else {
      return Colors.grey.shade800;
    }
  }

  IconData _getCrownIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.workspace_premium; // Gold crown
      case 2:
        return Icons.star; // Silver star
      case 3:
        return Icons.local_activity; // Bronze medal
      default:
        return Icons.workspace_premium;
    }
  }
}

class UserMarketTrendsCard extends StatelessWidget {
  final dynamic cropInfo;

  const UserMarketTrendsCard({
    super.key,
    required this.cropInfo,
  });

  @override
  Widget build(BuildContext context) {
    var imageURL = cropInfo['cropImage'] as String?;
    var ranking = cropInfo['ranking'] ?? 0;

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
            width: 1,
          ),
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
              // Updated Ranking Box
              RankingBox(ranking: ranking),

              const SizedBox(width: 20),

              // Crop Image
              SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
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

              const SizedBox(width: 20),

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

              const SizedBox(width: 20),

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