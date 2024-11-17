import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/widgets/app_bar/custom_app_bar.dart';
import 'package:myapp/ui/widgets/cards/user_cards/user_crop_report_card.dart';
import 'package:myapp/ui/widgets/custom_loading_indicator_v2.dart';
import 'package:myapp/ui/widgets/no_market_available.dart';

class UserCropReport extends StatefulWidget {
  const UserCropReport({super.key});

  @override
  State<UserCropReport> createState() => _UserCropReportState();
}

class _UserCropReportState extends State<UserCropReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(
          backgroundColor: const Color(0xFF133c0b).withOpacity(0.3),
          titleText: "Crop Reports",
          fontColor: const Color(0xFF3C4D48),
          onLeadingPressed: () {
            Navigator.pop(context); // Safely pops to the previous screen
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin_accounts')
            .doc('crop_reports')
            .collection('reports')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // DISPLAY CUSTOM LOADING INDICATOR
            return const CustomLoadingIndicator();
          }
          // IF FETCHING DATA HAS ERROR EXECUTE THIS
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // CHECK IF THERE IS AVAILABLE SERVICES
          if (snapshot.data?.docs.isEmpty ?? true) {
            // DISPLAY THERE IS NO AVAILABLE SERVICES
            return const NoMarketAvailable(
              screenName: 'crop reports',
            );
          } else {
            // DISPLAY AVAILABLE SERVICES: AS GRIDVIEW
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var cropReportInfo = snapshot.data!.docs[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: UserCropReportCard(cropReportInfo: cropReportInfo),
                );
              },
            );
          }
        },
      ),
    );
  }
}
