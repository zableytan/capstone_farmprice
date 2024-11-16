import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:myapp/services/admin_services.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator.dart';
import 'package:myapp/ui/widgets/snack_bar/custom_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // ****************** MARKETS SERVICES ****************** //

  // CREATE: MARKET
  static Future<void> createMarket({
    required BuildContext context,
    required String marketName,
    required PlatformFile? marketImage,
  }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);
      final userCredential = FirebaseAuth.instance.currentUser;
      if (userCredential == null) throw Exception("User not signed in");

      // Upload the market image
      final String? marketImageURL =
      await AdminServices.uploadFile(marketImage);

      // Generate a unique market ID
      String marketID =
          FirebaseFirestore.instance.collection('admin_accounts').doc().id;

      // Prepare the market data
      final marketData = {
        'marketID': marketID,
        'marketName': marketName,
        'marketImage': marketImageURL,
      };

      // Save the market data to Firestore
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('market_data')
          .collection('markets')
          .doc(marketID)
          .set(marketData);

      // IF CREATING SERVICE SUCCESSFUL
      if (context.mounted) {
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
        showFloatingSnackBar(
          context,
          'Market added successfully.',
          const Color(0xFF3C4D48),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // IF CREATING SERVICE FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error updating service: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  // READ: MARKET
  static Future<Map<String, dynamic>> getMarket(String marketID) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot marketSnapshot = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('market_data')
          .collection('markets')
          .doc(marketID)
          .get();

      // RETURN MARKETSNAPSHOT AS MAP
      return marketSnapshot.data() as Map<String, dynamic>;
    }
    return {};
  }

  // UPDATE: MARKET
  static Future<void> updateMarket({
    // PARAMETERS NEEDED
    required BuildContext context,
    required String marketID,
    required String marketName,
    PlatformFile? marketImage,
    String? oldImageURL,
  }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);

      final userCredential = FirebaseAuth.instance.currentUser;
      if (userCredential == null) throw Exception("User not signed in");

      final String? updatedImageURL = await AdminServices.uploadFile(
        marketImage,
        oldImageURL: oldImageURL,
      );

      if (updatedImageURL == null && oldImageURL == null) {
        debugPrint("UPDATED IMAGE: $updatedImageURL");
        throw Exception("Image upload failed, no image available to update.");
      }

      // Update the market data
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('market_data')
          .collection('markets')
          .doc(marketID)
          .update({
        'marketName': marketName,
        'marketImage': updatedImageURL ?? oldImageURL,
      });

      // IF ADDING SERVICE SUCCESSFUL
      if (context.mounted) {
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
        showFloatingSnackBar(
          context,
          'Market updated successfully.',
          const Color(0xFF3C4D48),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // IF ADDING SERVICE FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error updating services: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  // DELETE: MARKET
  static Future<void> deleteMarket(
      BuildContext context, {
        required String marketID,
      }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);

      // Delete the market document from Firestore
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('market_data')
          .collection('markets')
          .doc(marketID)
          .delete();

      // Dismiss the loading dialog first
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // IF DELETION SUCCESSFUL
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          'Market deleted successfully.',
          const Color(0xFF3C4D48),
        );
      }
    } catch (e) {
      // IF DELETION FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error deleting market: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
      }
    }
  }

  // ****************** CROP REPORT SERVICES ****************** //

  // CREATE: CROP REPORT
  static Future<void> createCropReport({
    required BuildContext context,
    required String cropReportDescription,
    required PlatformFile? cropReportImage,
  }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);
      final userCredential = FirebaseAuth.instance.currentUser;
      if (userCredential == null) throw Exception("User not signed in");

      // Upload the market image
      final String? cropReportImageURL =
      await AdminServices.uploadFile(cropReportImage);

      // Generate a unique market ID
      String cropReportID =
          FirebaseFirestore.instance.collection('admin_accounts').doc().id;

      // Prepare the market data
      final cropReportData = {
        'cropReport': cropReportID,
        'cropReportDescription': cropReportDescription,
        'cropReportImage': cropReportImageURL,
      };

      // Save the market data to Firestore
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crop_reports')
          .collection('reports')
          .doc(cropReportID)
          .set(cropReportData);

      // IF CREATING SERVICE SUCCESSFUL
      if (context.mounted) {
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
        showFloatingSnackBar(
          context,
          'Crop report created successfully.',
          const Color(0xFF3C4D48),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // IF CREATING SERVICE FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error updating service: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  // UPDATE: CROPREPORT
  static Future<void> updateCropReport({
    // PARAMETERS NEEDED
    required BuildContext context,
    required String marketID,
    required String description,
    PlatformFile? cropReportImage,
    String? oldImageURL,
  }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);

      final userCredential = FirebaseAuth.instance.currentUser;
      if (userCredential == null) throw Exception("User not signed in");

      final String? updatedImageURL = await AdminServices.uploadFile(
        cropReportImage,
        oldImageURL: oldImageURL,
      );

      if (updatedImageURL == null && oldImageURL == null) {
        debugPrint("UPDATED IMAGE: $updatedImageURL");
        throw Exception("Image upload failed, no image available to update.");
      }

      // Update the market data
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crop_reports')
          .collection('reports')
          .doc(marketID)
          .update({
        'cropReportDescription': description,
        'cropReportImage': updatedImageURL ?? oldImageURL,
      });

      // IF ADDING SERVICE SUCCESSFUL
      if (context.mounted) {
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
        showFloatingSnackBar(
          context,
          'Crop report updated successfully.',
          const Color(0xFF3C4D48),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // IF ADDING SERVICE FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error updating services: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  // READ: MARKET
  static Future<Map<String, dynamic>> getCropReport(String marketID) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot marketSnapshot = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crop_reports')
          .collection('reports')
          .doc(marketID)
          .get();

      // RETURN MARKETSNAPSHOT AS MAP
      return marketSnapshot.data() as Map<String, dynamic>;
    }
    return {};
  }

  // DELETE: MARKET
  static Future<void> deleteCropReport(
      BuildContext context, {
        required String marketID,
      }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);

      // Delete the market document from Firestore
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crop_reports')
          .collection('reports')
          .doc(marketID)
          .delete();

      // Dismiss the loading dialog first
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // IF DELETION SUCCESSFUL
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          'Crop report deleted successfully.',
          const Color(0xFF3C4D48),
        );
      }
    } catch (e) {
      // IF DELETION FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error deleting market: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
      }
    }
  }

  // ****************** CROPS SERVICES ****************** //

  // CREATE: CROP
  static Future<void> createCrop({
    required BuildContext context,
    required String cropName,
    required double retailPrice,
    required double wholeSalePrice,
    required double landingPrice,
    required PlatformFile? cropImage,
  }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);
      final userCredential = FirebaseAuth.instance.currentUser;
      if (userCredential == null) throw Exception("User not signed in");

      // Upload the market image
      final String? cropImageURL = await AdminServices.uploadFile(cropImage);

      // Generate a unique market ID
      String cropID =
          FirebaseFirestore.instance.collection('admin_accounts').doc().id;

      // Prepare the market data
      final cropsData = {
        'cropName': cropName,
        'cropID': cropID,
        'retailPrice': retailPrice,
        'previousRetailPrice': retailPrice,
        'wholeSalePrice': wholeSalePrice,
        'landingPrice': landingPrice,
        'oldRetailPrice': retailPrice,
        'cropImage': cropImageURL,
      };

      // Save the market data to Firestore
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropID)
          .set(cropsData);

      // IF CREATING SERVICE SUCCESSFUL
      if (context.mounted) {
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
        showFloatingSnackBar(
          context,
          'Crop added successfully.',
          const Color(0xFF3C4D48),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // IF CREATING SERVICE FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error updating service: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  // READ: CROP INFO
  static Future<Map<String, dynamic>> getCropInfo(String cropID) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot marketSnapshot = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropID)
          .get();

      // RETURN MARKETSNAPSHOT AS MAP
      return marketSnapshot.data() as Map<String, dynamic>;
    }
    return {};
  }

  // UPDATE: CROP
  static Future<void> updateCropInfo({
    // PARAMETERS NEEDED
    required BuildContext context,
    required String cropID,
    required String cropName,
    required double oldRetailPrice,
    required double retailPrice,
    required double wholeSalePrice,
    required double landingPrice,
    PlatformFile? cropImage,
    String? oldImageURL,
  }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);

      final userCredential = FirebaseAuth.instance.currentUser;
      if (userCredential == null) throw Exception("User not signed in");

      final String? updatedImageURL = await AdminServices.uploadFile(
        cropImage,
        oldImageURL: oldImageURL,
      );

      if (updatedImageURL == null && oldImageURL == null) {
        debugPrint("UPDATED IMAGE: $updatedImageURL");
        throw Exception("Image upload failed, no image available to update.");
      }

      // Update the market data
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropID)
          .update({
        'cropName': cropName,
        'retailPrice': retailPrice,
        'previousRetailPrice': retailPrice,
        'wholeSalePrice': wholeSalePrice,
        'landingPrice': landingPrice,
        'oldRetailPrice': oldRetailPrice,
        'cropImage': cropImage ?? oldImageURL,
      });

      // Now save the price to the history for today's date
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropID)
          .collection('crop_price_history')
          .add({
        'date': Timestamp.fromDate(DateTime.now()), // Save today's date
        'price': retailPrice, // Save the updated retail price
      });

      // IF ADDING SERVICE SUCCESSFUL
      if (context.mounted) {
        // Dismiss loading dialog
        Navigator.of(context).pop();
        showFloatingSnackBar(
          context,
          'Crop updated successfully.',
          const Color(0xFF3C4D48),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // IF ADDING SERVICE FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error updating services: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
        // Dismiss loading dialog
        Navigator.of(context).pop();
      }
    }
  }

  // DELETE: CROP
  static Future<void> deleteCrop(
      BuildContext context, {
        required String cropID,
      }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);

      // Delete the market document from Firestore
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('crops_available')
          .collection('crops')
          .doc(cropID)
          .delete();

      // Dismiss the loading dialog first
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // IF DELETION SUCCESSFUL
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          'Crop deleted successfully.',
          const Color(0xFF3C4D48),
        );
      }
    } catch (e) {
      // IF DELETION FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error deleting market: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
      }
    }
  }

  // ****************** TRENT MARKET SERVICES ****************** //

  // CREATE: CROP
  static Future<void> createTrendCrop({
    required BuildContext context,
    required String cropName,
    required double retailPrice,
    required PlatformFile? cropImage,
  }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);
      final userCredential = FirebaseAuth.instance.currentUser;
      if (userCredential == null) throw Exception("User not signed in");

      // Upload the market image
      final String? cropImageURL = await AdminServices.uploadFile(cropImage);

      // Generate a unique market ID
      String cropID =
          FirebaseFirestore.instance.collection('admin_accounts').doc().id;

      // Prepare the market data
      final cropsData = {
        'cropName': cropName,
        'cropID': cropID,
        'retailPrice': retailPrice,
        'previousRetailPrice': retailPrice,
        'cropImage': cropImageURL,
      };

      // Save the market data to Firestore
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('trend_market')
          .collection('trend_crops')
          .doc(cropID)
          .set(cropsData);

      // IF CREATING SERVICE SUCCESSFUL
      if (context.mounted) {
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
        showFloatingSnackBar(
          context,
          'Crop added successfully.',
          const Color(0xFF3C4D48),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // IF CREATING SERVICE FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error updating service: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
        // Dismiss loading dialog
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  // READ: CROP INFO
  static Future<Map<String, dynamic>> getTrendCrop(String cropID) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot marketSnapshot = await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('trend_market')
          .collection('trend_crops')
          .doc(cropID)
          .get();

      // RETURN MARKETSNAPSHOT AS MAP
      return marketSnapshot.data() as Map<String, dynamic>;
    }
    return {};
  }

  // UPDATE: CROP
  static Future<void> updateTrendCrop({
    // PARAMETERS NEEDED
    required BuildContext context,
    required String cropID,
    required String cropName,
    required double retailPrice,
    PlatformFile? cropImage,
    String? oldImageURL,
  }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);

      final userCredential = FirebaseAuth.instance.currentUser;
      if (userCredential == null) throw Exception("User not signed in");

      final String? updatedImageURL = await AdminServices.uploadFile(
        cropImage,
        oldImageURL: oldImageURL,
      );

      if (updatedImageURL == null && oldImageURL == null) {
        debugPrint("UPDATED IMAGE: $updatedImageURL");
        throw Exception("Image upload failed, no image available to update.");
      }

      // Update the market data
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('trend_market')
          .collection('trend_crops')
          .doc(cropID)
          .update({
        'cropName': cropName,
        'retailPrice': retailPrice,
        'cropImage': cropImage ?? oldImageURL,
      });

      // IF ADDING SERVICE SUCCESSFUL
      if (context.mounted) {
        // Dismiss loading dialog
        Navigator.of(context).pop();
        showFloatingSnackBar(
          context,
          'Crop updated successfully.',
          const Color(0xFF3C4D48),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      // IF ADDING SERVICE FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error updating services: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
        // Dismiss loading dialog
        Navigator.of(context).pop();
      }
    }
  }

  // DELETE: CROP
  static Future<void> deleteTrendCrop(
      BuildContext context, {
        required String cropID,
      }) async {
    try {
      // DISPLAY LOADING DIALOG
      showLoadingIndicator(context);

      // Delete the market document from Firestore
      await FirebaseFirestore.instance
          .collection('admin_accounts')
          .doc('trend_market')
          .collection('trend_crops')
          .doc(cropID)
          .delete();

      // Dismiss the loading dialog first
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // IF DELETION SUCCESSFUL
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          'Trend Crop deleted successfully.',
          const Color(0xFF3C4D48),
        );
      }
    } catch (e) {
      // IF DELETION FAILED
      if (context.mounted) {
        showFloatingSnackBar(
          context,
          "Error deleting market: ${e.toString()}",
          const Color(0xFFe91b4f),
        );
      }
    }
  }
}
