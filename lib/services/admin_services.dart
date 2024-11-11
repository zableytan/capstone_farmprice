import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/image_compression.dart';

// CLASS FOR PROVIDER'S SERVICES: SELECT IMAGE, UPLOAD IMAGE
class AdminServices {
  // SELECT IMAGE
  static Future selectImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    return result.files.first;
  }

  // UPLOAD IMAGE FOR SERVICES
  static Future uploadFile(
    PlatformFile? selectedImage, {
    String? oldImageURL,
  }) async {
    if (selectedImage == null || selectedImage.path == null) {
      return null;
    }

    // COMPRESS THE IMAGE
    final File compressedImage = await compressImage(File(selectedImage.path!));

    final path =
        'marketImages/${FirebaseAuth.instance.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}_${selectedImage.name}';
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      await ref.putFile(compressedImage);
      final String downloadURL = await ref.getDownloadURL();

      if (oldImageURL != null && oldImageURL.isNotEmpty) {
        final oldImageRef = FirebaseStorage.instance.refFromURL(oldImageURL);
        await oldImageRef.delete();
        debugPrint("Old image deleted successfully.");
      }
      return downloadURL;
    } on FirebaseException catch (e) {
      debugPrint("Firebase Exception during file upload: ${e.message}");
    } catch (e) {
      debugPrint("Error during file upload: $e");
    }
    return null;
  }
}