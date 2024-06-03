import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';

import 'package:project_proud_me/widgets/app_drawer.dart';
import '../language.dart';
import '../constant.dart';
import '../introduction/introduction.dart';
import '../utils/logout.dart';
import './activity.dart';

class MyJournalScreen extends StatefulWidget {
  @override
  _MyJournalScreenState createState() => _MyJournalScreenState();
}

class _MyJournalScreenState extends State<MyJournalScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading ?
    const Center(
      child: CircularProgressIndicator(),
    ) :
    Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xfff5b342)),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
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
            onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  logout();

                  setState(() {
                    _isLoading = false;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Introduction()),
                  );
                },
            icon: const Icon(
              Icons.logout,
              color: Color(0xfff5b342),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.90,
              child: AppinioSwiper(
                swipeOptions: const SwipeOptions.only(up: false, down: false, right: true, left: true),
                loop: true,
                cardCount: 4,
                cardBuilder: (BuildContext context, int index) {
                  switch (index) {
                    case 0 :
                      return ActivityCard();
                    case 1:
                      return ActivityCard();
                    case 2:
                      return ActivityCard();
                    case 3:
                      return ActivityCard();
                    default:
                      throw Exception();
                  }
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}
