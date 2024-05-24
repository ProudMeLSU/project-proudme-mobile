import 'package:flutter/material.dart';

import '../constant.dart';

class MyDrawer extends StatelessWidget {
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
              'Menu',
              style: TextStyle(
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
