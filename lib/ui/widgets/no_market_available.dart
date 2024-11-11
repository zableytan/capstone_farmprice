import 'package:flutter/material.dart';

class NoMarketAvailable extends StatelessWidget {
  final String? screenName;

  const NoMarketAvailable({
    super.key,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(top: 200, bottom: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFc2c3c3),
                  width: 2,
                )),
            child: const Icon(
              Icons.archive,
              color: Color(0xFFc2c3c3),
              size: 40,
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "No $screenName available\n",
                  style: const TextStyle(
                    color: Color(0xFFc2c3c3),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text:
                      "\nWhen you have listed $screenName, you'll see\nthem here.",
                  style: const TextStyle(
                    color: Color(0xFFc2c3c3),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
