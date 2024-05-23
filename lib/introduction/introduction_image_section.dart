import 'package:flutter/material.dart';

import '../language.dart';
import '../constant.dart';

class IntroductionImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Container(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    schoolKidsPicPath,
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
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
            )  
    );
  }
}
