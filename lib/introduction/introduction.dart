import 'package:flutter/material.dart';

import '../user-account/sign_in.dart';
import 'introduction_appbar.dart';
import 'introduction_image_section.dart';
import '../language.dart';
import 'introduction_list_section.dart';
import 'introduction_footer_section.dart';
import '../constant.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: projectTitle,
      home: Scaffold(
        appBar: IntroductionAppBar(
          title: '',
          onSignInPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
          onPressed: () {

          }
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IntroductionImageSection(),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  introductionStartingText,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextListWidget(
                  title: journalHeader,
                  texts: journalList
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextListWidget(
                  title: peHeader,
                  texts: peList
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextListWidget(
                  title: cafeteriaHeader,
                  texts: cafeteriaList
                )
              ),
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: IntroductionFooterWidget(regularText: introductionEndingText1, clickableText: labEmail)
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: IntroductionFooterWidget(regularText: introductionEndingText2, clickableText: piEmail)
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
