import 'dart:convert' show jsonDecode;
import 'package:flutter/material.dart';
import 'package:project_proud_me/constant.dart';
import 'package:project_proud_me/journal/my_journal.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class MyDrawer extends StatefulWidget {

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _welcomeText = '';

  @override
  void initState() {
    super.initState();
    fetchMenuText();
  }

  Future<void> fetchMenuText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(userDataKey)) {
      Map<String, dynamic> userData = jsonDecode(
        prefs.getString(userDataKey) ?? 'Menu'
      );

      setState(() {
        _welcomeText =  'Hi, ${userData['name']}!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              _welcomeText,
              style: const TextStyle(
                color: Color(0xfff5b342),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Project Team',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily
              ),
            ),
            onTap: () {
            },
          ),
          ListTile(
            title: Text(
              'My Journal',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily
              )
            ),
            onTap: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyJournalScreen()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Behaviour Charts',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily
              )
            ),
            onTap: () {
            },
          ),
          ListTile(
            title: Text(
              'ProudMe PE',
              style: TextStyle( 
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily
              )            
            ),
            onTap: () {
            },
          ),
          ListTile(
            title: Text(
              'ProudMe Cafeteria',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily
              )            
            ),
            onTap: () {
            },
          ),
          ListTile(
            title: Text(
              'ProudMe Tech',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily
              )            
            ),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}
