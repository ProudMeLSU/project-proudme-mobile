import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';

class IntroductionFooterWidget extends StatelessWidget {
  final String regularText;
  final String clickableText;

  const IntroductionFooterWidget({
    Key? key,
    required this.regularText,
    required this.clickableText
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              regularText,
              style: TextStyle(fontSize: 16.0, fontFamily: fontFamily),
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                String mailUrl = 'mailto:$clickableText';
                try {
                  await _launchUrl(Uri.parse(mailUrl));
                } catch (e) {
                  //Log error
                }
              },
              icon: Icon(Icons.email),
              label: Text('$clickableText'),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
