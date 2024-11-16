import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomAppBar extends StatelessWidget {
  // PARAMETERS NEEDED
  final Color backgroundColor;
  final Color fontColor;
  final String titleText;
  final VoidCallback onLeadingPressed;

  // CONSTRUCTORS FOR CREATING NEW INSTANCE/OBJECT
  const CustomAppBar({
    super.key,
    required this.fontColor,
    required this.backgroundColor,
    this.titleText = "",
    required this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0.0,
      leading: IconButton(
        onPressed: onLeadingPressed,
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
        ),
      ),
      centerTitle: true,
      title: AutoSizeText(
        titleText,
        style: TextStyle(
          color: fontColor,
          fontWeight: FontWeight.bold,
        ),
        minFontSize: 13,
        maxFontSize: 18,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
