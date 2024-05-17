import 'package:flutter/material.dart';

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
                    'assets/school_kids.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                    child: Text(
                      'Welcome to ProudMe!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            )  
    );
  }
}
