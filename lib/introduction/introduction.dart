import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'package:project_proud_me/constant.dart';
import 'package:project_proud_me/endpoints.dart';
import 'package:project_proud_me/introduction/introduction_footer_section.dart';
import 'package:project_proud_me/introduction/introduction_image_section.dart';
import 'package:project_proud_me/introduction/introduction_list_section.dart';
import 'package:project_proud_me/language.dart';
import 'package:project_proud_me/user-account/sign_in.dart';
import 'package:project_proud_me/utils/helpers.dart';
import 'package:project_proud_me/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class Introduction extends StatefulWidget {

  @override
  _IntroductionState createState() => _IntroductionState();

}

class _IntroductionState extends State<Introduction> {
  bool _isSignedIn = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(authTokenKey);

    if (authToken == null) {
      setState(() {
        _isSignedIn = false;
        _isLoading = false;
      });

      return;
    }
    
    try {
      var response = await get(
        Uri.parse(users),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        await prefs.setString(userDataKey, response.body);

        setState(() {
          _isSignedIn = true;
        });
      } else if (response.statusCode == 401) {
        await prefs.remove(authTokenKey);
        await prefs.remove(userDataKey);

        setState(() {
          _isSignedIn = false;
        });
      }
    } catch (e) {
      setState(() {
        _isSignedIn = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: projectTitle,
      home: _isLoading ?
        const Center(
          child: CircularProgressIndicator()
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
                onPressed: _isSignedIn ?
                () async {
                  setState(() {
                    _isLoading = true;
                  });
                  
                  logout();

                  setState(() {
                    _isSignedIn = false;
                    _isLoading = false;
                  });
                } :
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen(redirectionFromVerificationScreen: false,)),
                  );
                },
                icon: Icon(
                  _isSignedIn ? Icons.logout : Icons.person,
                  color: const Color(0xfff5b342),
                ),
              ),
            ],
          ),
        drawer: _isSignedIn ? MyDrawer() : null,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IntroductionImageSection(),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  introductionStartingText,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextListWidget(
                  title: journalHeader,
                  texts: journalList
                )
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextListWidget(
                  title: peHeader,
                  texts: peList
                )
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: TextListWidget(
                  title: cafeteriaHeader,
                  texts: cafeteriaList
                )
              ),
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: const IntroductionFooterWidget(regularText: introductionEndingText1, clickableText: labEmail)
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: const IntroductionFooterWidget(regularText: introductionEndingText2, clickableText: piEmail)
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
