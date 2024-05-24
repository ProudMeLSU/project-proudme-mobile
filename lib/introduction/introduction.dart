import 'package:flutter/material.dart';

import '../user-account/sign_in.dart';
import 'introduction_image_section.dart';
import '../language.dart';
import 'introduction_list_section.dart';
import 'introduction_footer_section.dart';
import '../constant.dart';
import '../widgets/app_drawer.dart';

class Introduction extends StatelessWidget {
  final bool isSignedIn = true;

  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: projectTitle,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xfff5b342)),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
                projectTitle,
                style: TextStyle(
                  color: Color(0xfff5b342),
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily,
                ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: isSignedIn ?
              () {} :
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              icon: Icon(
                isSignedIn ? Icons.logout : Icons.person,
                color: Color(0xfff5b342),
              ),
            ),
          ],
        ),
        drawer: isSignedIn ? MyDrawer() : null,
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
