import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_service.dart';
import 'package:myapp/services/image_service.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/custom_button.dart';
import 'package:myapp/ui/widgets/custom_text_field.dart';

class UpdateMarket extends StatefulWidget {
  final String marketID;

  const UpdateMarket({
    super.key,
    required this.marketID,
  });

  @override
  State<UpdateMarket> createState() => _UpdateMarketState();
}

class _UpdateMarketState extends State<UpdateMarket> {
  // CONTROLLERS
  final TextEditingController _marketNameController = TextEditingController();

  // FOCUS NODES
  final FocusNode _marketNameFocusNode = FocusNode();

  // VARIABLE DECLARATION
  PlatformFile? marketView;
  String? imageULR;
  String? oldImageURL;
  bool isLoading = true;

  // INITIALIZE
  @override
  void initState() {
    super.initState();
    getMarkets();
  }

  // DISPOSE
  @override
  void dispose() {
    _marketNameController.dispose();
    _marketNameFocusNode.dispose();
    super.dispose();
  }

  // MARKET VIEW IMAGE
  Future<void> marketImageSelection() async {
    final selected = await ImageService.selectImage();
    if (selected != null) {
      setState(() {
        marketView = selected;
      });
    }
  }

  // METHOD THAT WILL GET THE MARKETS
  void getMarkets() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await FirebaseService.getMarket(widget.marketID);

      if (mounted) {
        setState(() {
          _marketNameController.text = data['marketName'];
          imageULR = data['marketImage'];
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
  void handleUpdateMarket() async {
    await FirebaseService.updateMarket(
      context: context,
      marketID: widget.marketID,
      marketName: _marketNameController.text,
      marketImage: marketView,
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
          titleText: "Market Information",
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

            // Market Name and Image section
            const Text(
              "Market Name",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C4D48),
              ),
            ),
            const SizedBox(height: 2),
            CustomTextField(
              controller: _marketNameController,
              currentFocusNode: _marketNameFocusNode,
              nextFocusNode: null,
              keyBoardType: null,
              inputFormatters: null,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Market name is required";
                }
                return null;
              },
              hintText: "Enter market name",
              minLines: 1,
              maxLines: 1,
              isPassword: false,
              prefixIcon: null,
            ),
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
                if (marketView == null) {
                  marketImageSelection();
                }
              },
              child: marketView != null || imageULR != null
                  ? Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: marketView != null
                              ? Image.file(
                                  File(marketView!.path!),
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
                                marketView = null;
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
              onPressed: handleUpdateMarket,
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
