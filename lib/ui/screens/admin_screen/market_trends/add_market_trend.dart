import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/services/firebase_service.dart';
import 'package:myapp/services/image_service.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'package:myapp/ui/widgets/custom_text_field.dart';

class AddMarketTrend extends StatefulWidget {
  const AddMarketTrend({super.key});

  @override
  State<AddMarketTrend> createState() => _AddMarketTrendState();
}

class _AddMarketTrendState extends State<AddMarketTrend> {
  // CONTROLLERS
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  final TextEditingController _wholesalePriceController = TextEditingController(); // Wholesale price controller
  final TextEditingController _landingPriceController = TextEditingController(); // Landing price controller
  final TextEditingController _rankingController = TextEditingController(); // Ranking controller

  // FOCUS NODES
  final FocusNode _cropNameFocusNode = FocusNode();
  final FocusNode _retailPriceFocusNode = FocusNode();
  final FocusNode _wholesalePriceFocusNode = FocusNode(); // Focus node for wholesale price
  final FocusNode _landingPriceFocusNode = FocusNode(); // Focus node for landing price
  final FocusNode _rankingFocusNode = FocusNode(); // Focus node for ranking

  // VARIABLE DECLARATION
  PlatformFile? cropImage;

  // DISPOSE
  @override
  void dispose() {
    _cropNameController.dispose();
    _retailPriceController.dispose();
    _wholesalePriceController.dispose();
    _landingPriceController.dispose();
    _rankingController.dispose();
    _cropNameFocusNode.dispose();
    _retailPriceFocusNode.dispose();
    _wholesalePriceFocusNode.dispose();
    _landingPriceFocusNode.dispose();
    _rankingFocusNode.dispose();
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

  // METHOD THAT WILL CREATE CROP INFO
  void handleCreateCrop() async {
    if (_cropNameController.text.isEmpty ||
        cropImage == null ||
        _rankingController.text.isEmpty ||
        _retailPriceController.text.isEmpty ||
        _wholesalePriceController.text.isEmpty ||
        _landingPriceController.text.isEmpty) {
      print("Please provide all required fields");
      return;
    }

    await FirebaseService.createTrendCrop(
      context: context,
      cropName: _cropNameController.text,
      retailPrice: double.parse(_retailPriceController.text),
      wholeSalePrice: double.parse(_wholesalePriceController.text), // Pass wholesale price
      landingPrice: double.parse(_landingPriceController.text), // Pass landing price
      cropImage: cropImage,
      ranking: int.parse(_rankingController.text), // Pass ranking
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
          titleText: "Trend Crop Information",
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
              nextFocusNode: _wholesalePriceFocusNode,
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

            const SizedBox(height: 10),

            // CROP WHOLESALE PRICE
            const Text(
              "Wholesale Price",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4D48),
              ),
            ),
            const SizedBox(height: 2),
            CustomTextField(
              controller: _wholesalePriceController,
              currentFocusNode: _wholesalePriceFocusNode,
              nextFocusNode: _landingPriceFocusNode,
              keyBoardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return "Wholesale price is required";
                }
                return null;
              },
              hintText: "00.00",
              minLines: 1,
              maxLines: 1,
              isPassword: false,
              prefixIcon: null,
            ),

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
              nextFocusNode: _rankingFocusNode,
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

            const SizedBox(height: 10),

            // CROP RANKING
            const Text(
              "Crop Ranking",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4D48),
              ),
            ),
            const SizedBox(height: 2),
            CustomTextField(
              controller: _rankingController,
              currentFocusNode: _rankingFocusNode,
              nextFocusNode: null,
              keyBoardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value!.isEmpty) {
                  return "Ranking is required";
                } else if (int.tryParse(value) == null || int.parse(value) < 1 || int.parse(value) > 10) {
                  return "Ranking must be between 1 and 10";
                }
                return null;
              },
              hintText: "1",
              minLines: 1,
              maxLines: 1,
              isPassword: false,
              prefixIcon: null,
            ),

            const SizedBox(height: 10),

            const Text(
              "Crop Image",
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
                if (cropImage == null) {
                  cropImageSelection();
                }
              },
              child: cropImage != null
                  ? Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(cropImage!.path!),
                      width: double.infinity,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          cropImage = null;
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
                      "Crop Image",
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

            const SizedBox(height: 15),

            // ADD BUTTON
            CustomButton(
              onPressed: handleCreateCrop,
              buttonHeight: 50,
              buttonColor: const Color(0xFF3C4D48),
              fontWeight: FontWeight.w500,
              fontSize: 17,
              fontColor: Colors.white,
              borderRadius: 10,
              buttonLabel: "List Trend Crop",
            ),
          ],
        ),
      ),
    );
  }
}
