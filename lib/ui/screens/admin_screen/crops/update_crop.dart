import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/services/firebase_service.dart';
import 'package:myapp/services/image_service.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'package:myapp/ui/widgets/custom_text_field.dart';

class UpdateCrop extends StatefulWidget {
  final String cropID;

  const UpdateCrop({
    super.key,
    required this.cropID,
  });

  @override
  State<UpdateCrop> createState() => _UpdateCropState();
}

class _UpdateCropState extends State<UpdateCrop> {
  // CONTROLLERS
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  final TextEditingController _oldRetailPriceController =
      TextEditingController();
  final TextEditingController _wholeSalePriceController =
      TextEditingController();
  final TextEditingController _landingPriceController = TextEditingController();

  // FOCUS NODES
  final FocusNode _cropNameFocusNode = FocusNode();
  final FocusNode _retailPriceFocusNode = FocusNode();
  final FocusNode _wholeSalePriceFocusNode = FocusNode();
  final FocusNode _landingPriceFocusNode = FocusNode();

  // VARIABLE DECLARATION
  PlatformFile? cropImage;
  String? imageULR;
  String? oldImageURL;
  bool isLoading = true;

  // INITIALIZE
  @override
  void initState() {
    super.initState();
    getCropsInfo();
  }

  // DISPOSE
  @override
  void dispose() {
    _cropNameController.dispose();
    _retailPriceController.dispose();
    _wholeSalePriceController.dispose();
    _landingPriceController.dispose();
    _cropNameFocusNode.dispose();
    _retailPriceFocusNode.dispose();
    _wholeSalePriceFocusNode.dispose();
    _landingPriceFocusNode.dispose();
    _oldRetailPriceController.dispose();
    super.dispose();
  }

  // MARKET VIEW IMAGE
  Future<void> cropImageSelection() async {
    final selected = await ImageService.selectImage();
    if (selected != null) {
      setState(() {
        cropImage = selected;
      });
    }
  }

  // METHOD THAT WILL GET THE MARKETS
  void getCropsInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await FirebaseService.getCropInfo(widget.cropID);

      if (mounted) {
        setState(() {
          _cropNameController.text = data['cropName'];
          _retailPriceController.text = data['retailPrice'].toString();
          _wholeSalePriceController.text = data['wholeSalePrice'].toString();
          _landingPriceController.text = data['landingPrice'].toString();
          imageULR = data['cropImage'];
          oldImageURL = imageULR;
          _oldRetailPriceController.text = data['retailPrice'].toString();
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
  void handleUpdateCrop() async {
    await FirebaseService.updateCropInfo(
      context: context,
      cropID: widget.cropID,
      cropName: _cropNameController.text,
      oldRetailPrice: double.parse(_oldRetailPriceController.text),
      retailPrice: double.parse(_retailPriceController.text),
      wholeSalePrice: double.parse(_wholeSalePriceController.text),
      landingPrice: double.parse(_landingPriceController.text),
      cropImage: cropImage,
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
          titleText: "Crop Information",
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

            // CROP NAME
            const Text(
              "Crop Name",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4D48),
              ),
            ),
            const SizedBox(height: 2),
            CustomTextField(
              controller: _cropNameController,
              currentFocusNode: _cropNameFocusNode,
              nextFocusNode: _retailPriceFocusNode,
              keyBoardType: null,
              inputFormatters: null,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Crop name is required";
                }
                return null;
              },
              hintText: "Crop Name",
              minLines: 1,
              maxLines: 1,
              isPassword: false,
              prefixIcon: null,
            ),

            const SizedBox(height: 10),

            // CROP RETAIL PRICE
            const Text(
              "Retail Price",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4D48),
              ),
            ),
            const SizedBox(height: 2),
            CustomTextField(
              controller: _retailPriceController,
              currentFocusNode: _retailPriceFocusNode,
              nextFocusNode: _wholeSalePriceFocusNode,
              keyBoardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return "Retail price is required";
                }
                return null;
              },
              hintText: "00.00",
              minLines: 1,
              maxLines: 1,
              isPassword: false,
              prefixIcon: null,
            ),

            // SPACING
            const SizedBox(height: 10),

            // CROP WHOLE PRICE
            const Text(
              "Whole Price",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4D48),
              ),
            ),
            const SizedBox(height: 2),
            CustomTextField(
              controller: _wholeSalePriceController,
              currentFocusNode: _wholeSalePriceFocusNode,
              nextFocusNode: _landingPriceFocusNode,
              keyBoardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return "Whole price is required";
                }
                return null;
              },
              hintText: "00.00",
              minLines: 1,
              maxLines: 1,
              isPassword: false,
              prefixIcon: null,
            ),

            // SPACING
            const SizedBox(height: 10),

            // CROP LANDING PRICE
            const Text(
              "Landing Price",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4D48),
              ),
            ),
            const SizedBox(height: 2),
            CustomTextField(
              controller: _landingPriceController,
              currentFocusNode: _landingPriceFocusNode,
              nextFocusNode: null,
              keyBoardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return "Landing price is required";
                }
                return null;
              },
              hintText: "00.00",
              minLines: 1,
              maxLines: 1,
              isPassword: false,
              prefixIcon: null,
            ),

            // SPACING
            const SizedBox(height: 10),

            const Text(
              "Market Image",
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
                minimumSize: const Size(double.infinity, 90),
              ),
              onPressed: () {
                if (cropImage == null) {
                  cropImageSelection();
                }
              },
              child: cropImage != null || imageULR != null
                  ? Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: cropImage != null
                              ? Image.file(
                                  File(cropImage!.path!),
                                  // Use the path of the selected image
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
                                cropImage = null;
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
                            "Market View",
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
            const SizedBox(height: 15),

            // BUTTON: SAVE PHONE NUMBER
            CustomButton(
              onPressed: handleUpdateCrop,
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
