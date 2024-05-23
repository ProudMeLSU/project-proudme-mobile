import 'package:flutter/material.dart';
import 'introduction/introduction.dart';

import 'language.dart';
import 'constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: projectTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          secondary: Color(0xfff5b342)
        ),
        useMaterial3: true,
        fontFamily: fontFamily
      ),
      home: Scaffold(
        body: Introduction()
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
