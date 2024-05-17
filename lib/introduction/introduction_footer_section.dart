import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat'),
            ),
          GestureDetector(
            onTap: () async {
              String mailUrl = 'mailto:$clickableText';
              try {
                await _launchUrl(Uri.parse(mailUrl));
              } catch (e) {
                //Log error
              }
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center, 
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                clickableText,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Montserrat',
                  color: Colors.blue,
                ),
              ),
            )
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
