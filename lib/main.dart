import 'package:flutter/material.dart';
import 'package:project_proud_me/constant.dart';
import 'package:project_proud_me/introduction/introduction.dart' show Introduction;
import 'package:project_proud_me/language.dart';

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
          secondary: const Color(0xfff5b342)
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
