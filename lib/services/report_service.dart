import 'package:flutter/material.dart';
import 'package:myapp/services/crop_services.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator.dart';
import 'package:myapp/ui/widgets/loading_indicator_generating.dart';
import 'package:myapp/ui/widgets/snack_bar/custom_snack_bar.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'; // Import Syncfusion XlsIO package
import 'package:intl/intl.dart'; // Import intl package for date formatting

Future<void> generateCropsReport(BuildContext context) async {
  try {
    // Show loading indicator
    showLoadingIndicatorv2(context);

    // Fetch the latest price for all crops
    final List<Map<String, dynamic>> crops = await CropService.fetchLatestCropsWithPrice();

    if (crops.isEmpty) {
      if (context.mounted) {
        Navigator.of(context).pop();
        showFloatingSnackBar(context, 'No crops found!', Colors.orange);
      }
      return;
    }

    // Initialize the workbook
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0]; // Access the first sheet

    // Add headers to the Excel sheet
    sheet.getRangeByIndex(1, 1).setText('Crop Name');
    sheet.getRangeByIndex(1, 2).setText('Retail Price');
    sheet.getRangeByIndex(1, 3).setText('Wholesale Price');
    sheet.getRangeByIndex(1, 4).setText('Landing Price');
    sheet.getRangeByIndex(1, 5).setText('Latest Date');
    sheet.getRangeByIndex(1, 6).setText('Latest Price');

    // Initialize DateFormat to format date as "yyyy-MM-dd"
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    // Add each crop's data
    for (var i = 0; i < crops.length; i++) {
      var crop = crops[i];
      // Format prices to show decimals
      sheet.getRangeByIndex(i + 2, 1).setText(crop['cropName']);
      sheet.getRangeByIndex(i + 2, 2).setText(crop['retailPrice'].toStringAsFixed(2)); // Retail price with 2 decimal points
      sheet.getRangeByIndex(i + 2, 3).setText(crop['wholeSalePrice'].toStringAsFixed(2)); // Wholesale price with 2 decimal points
      sheet.getRangeByIndex(i + 2, 4).setText(crop['landingPrice'].toStringAsFixed(2)); // Landing price with 2 decimal points
      sheet.getRangeByIndex(i + 2, 5).setText(dateFormat.format((crop['latestDate'] as Timestamp).toDate())); // Formatted date
      sheet.getRangeByIndex(i + 2, 6).setText(crop['latestPrice'].toStringAsFixed(2)); // Latest price with 2 decimal points
    }



    // Get Downloads directory path
    String filePath = '';
    if (Platform.isAndroid) {
      if (await Directory('/storage/emulated/0/Download').exists()) {
        filePath = '/storage/emulated/0/Download/FarmPrice_Crops_Reports.xlsx';  // Use formatted date in file name
      } else {
        final directory = await getExternalStorageDirectory();
        filePath = '${directory?.path}/FarmPrice_Crops_Reports.xlsx';  // Fall-back path
      }
    } else {
      final directory = await getApplicationDocumentsDirectory();
      filePath = '${directory.path}/FarmPrice_Crops_Reports.xlsx';  // Fallback for other platforms (like iOS)
    }

    // Save the Excel file
    final List<int> bytes = workbook.saveAsStream();
    final File file = File(filePath);
    await file.writeAsBytes(bytes);

    // Dismiss loading indicator
    if (context.mounted) Navigator.of(context).pop();

    // Show success message
    showFloatingSnackBar(
      context,
      'Excel report generated successfully at $filePath',
      const Color(0xFF3C4D48),
    );
  } catch (e) {
    // Handle errors
    if (context.mounted) {
      Navigator.of(context).pop();
      showFloatingSnackBar(
        context,
        "Error generating report: ${e.toString()}",
        const Color(0xFFe91b4f),
      );
    }
  }
}
