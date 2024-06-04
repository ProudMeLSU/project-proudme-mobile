import 'package:flutter/material.dart';
import 'package:project_proud_me/constant.dart';
import 'package:project_proud_me/language.dart';

class IntroductionImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
        Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    schoolKidsPicPath,
                    fit: BoxFit.cover,
                  ),
                ),
                const Center(
                    child: Text(
                      welcomeMessage,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
              ],
            );
  }
}
