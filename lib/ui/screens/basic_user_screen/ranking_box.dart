import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart'; // Import FontAwesome icons

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ranking == 1) ...[
            Icon(
              FontAwesome.crop, // Use FontAwesome's crown icon
              color: textColor,
              size: 20,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            '#$ranking',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) {
      return const Color(0xFFFFD700).withOpacity(0.85); // Gold
    } else if (rank >= 2 && rank <= 5) {
      return const Color(0xFFC0C0C0).withOpacity(0.85); // Silver
    } else {
      return const Color(0xFFCD7F32).withOpacity(0.85); // Bronze
    }
  }

  Color _getTextColor(int rank) {
    if (rank == 1) {
      return Colors.brown.shade900;
    } else if (rank >= 2 && rank <= 5) {
      return Colors.grey.shade900;
    } else {
      return Colors.brown.shade900;
    }
  }
}
