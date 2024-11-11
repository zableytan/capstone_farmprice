import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_service.dart';
import 'package:myapp/services/image_service.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'package:myapp/ui/widgets/custom_text_field.dart';

class UpdateCropReport extends StatefulWidget {
  final String cropReportID;

  const UpdateCropReport({
    super.key,
    required this.cropReportID,
  });

  @override
  State<UpdateCropReport> createState() => _UpdateCropReportState();
}

class _UpdateCropReportState extends State<UpdateCropReport> {
  // CONTROLLERS
  final TextEditingController _descriptionController = TextEditingController();

  // FOCUS NODES
  final FocusNode _descriptionFocusNode = FocusNode();

  // VARIABLE DECLARATION
  //PlatformFile? marketView;
  PlatformFile? cropReportImage;
  String? imageULR;
  String? oldImageURL;
  bool isLoading = true;

  // INITIALIZE
  @override
  void initState() {
    super.initState();
    getCropReports();
  }

  // DISPOSE
  @override
  void dispose() {
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  // MARKET VIEW IMAGE
  Future<void> marketImageSelection() async {
    final selected = await ImageService.selectImage();
    if (selected != null) {
      setState(() {
        cropReportImage = selected;
      });
    }
  }

  // METHOD THAT WILL GET THE MARKETS
  void getCropReports() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await FirebaseService.getCropReport(widget.cropReportID);

      if (mounted) {
        setState(() {
          _descriptionController.text = data['cropReportDescription'];
          imageULR = data['cropReportImage'];
          oldImageURL = imageULR;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user services: $e');
    }
  }

  // METHOD THAT WILL SAVED MARKET INFO
  void handleUpdateCropReport() async {
    await FirebaseService.updateCropReport(
      context: context,
      marketID: widget.cropReportID,
      description: _descriptionController.text,
      cropReportImage: cropReportImage,
      oldImageURL: oldImageURL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(
          backgroundColor: const Color(0xFF133c0b).withOpacity(0.3),
          titleText: "Crop Report Information",
          fontColor: const Color(0xFF3C4D48),
          onLeadingPressed: () {
            Navigator.pop(context); // Safely pops to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15),

            const Text(
              "Crop Report Image",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4D48),
              ),
            ),
            const SizedBox(height: 2),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: const Color.fromARGB(255, 233, 238, 233),
                foregroundColor: const Color(0xFFBDBDC7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(
                  color: Color(0xFFBDBDC7),
                  width: 1.5,
                ),
                elevation: 0,
                minimumSize: const Size(double.infinity, 130),
              ),
              onPressed: () {
                if (cropReportImage == null) {
                  marketImageSelection();
                }
              },
              child: cropReportImage != null || imageULR != null
                  ? Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: cropReportImage != null
                              ? Image.file(
                                  File(cropReportImage!.path!),
                                  width: double.infinity,
                                  height: 130,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imageULR!,
                                  width: double.infinity,
                                  height: 130,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "lib/ui/assets/no_image.jpeg",
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: double.infinity,
                                    );
                                  },
                                ),
                        ),
                        Positioned(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                cropReportImage = null;
                                imageULR = null;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.clear_rounded,
                                color: Color(0xFFF5F5F5),
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.add_a_photo_rounded,
                            color: Colors.grey,
                          ),
                          Text(
                            "Crop Rerort Image",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // SPACING
            const SizedBox(height: 10),

            const Text(
              "Crop Report Description",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4D48),
              ),
            ),

            const SizedBox(height: 2),

            CustomTextField(
              controller: _descriptionController,
              currentFocusNode: _descriptionFocusNode,
              nextFocusNode: null,
              keyBoardType: null,
              inputFormatters: null,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Description is required";
                }
                return null;
              },
              hintText: "Report description...",
              minLines: 1,
              maxLines: 5,
              isPassword: false,
              prefixIcon: null,
            ),

            // SPACING
            const SizedBox(height: 15),

            // BUTTON: SAVE PHONE NUMBER
            CustomButton(
              onPressed: handleUpdateCropReport,
              buttonHeight: 50,
              buttonColor: const Color(0xFF3C4D48),
              fontWeight: FontWeight.w500,
              fontSize: 17,
              fontColor: Colors.white,
              borderRadius: 10,
              buttonLabel: "Publish",
            ),

            // SPACING
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
