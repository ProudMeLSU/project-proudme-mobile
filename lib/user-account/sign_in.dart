import 'package:flutter/material.dart';
import 'dart:convert';

import 'sign_up.dart';
import 'forgot_credentials.dart';
import '../constant.dart';
import '../language.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Map<String, dynamic> formData = {
    'email': '',
    'password': '',
  };

  bool allFieldsFilled = false;

  void updateFormData(String field, dynamic value) {
    setState(() {
      formData[field] = value;

      allFieldsFilled = formData.values.every((element) => element != '');
    });
  }

  void handleLogin(BuildContext context) {
    String jsonData = jsonEncode(formData);
    print(jsonData);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'API integration hasn\'t been implemented yet!',
          style: TextStyle(
            color: Colors.white,
            fontFamily: fontFamily,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
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
        ),
        body: BodyElement(
          handleLogin: handleLogin,
          updateFormData: updateFormData,
          allFieldsFilled: allFieldsFilled
        )
      ),
      debugShowCheckedModeBanner: false,

    );
  }
}

class BodyElement extends StatelessWidget {
  final bool allFieldsFilled;
  final Function(BuildContext) handleLogin;
  final Function(String, dynamic) updateFormData;

    const BodyElement({
      Key? key,
      required this.handleLogin,
      required this.updateFormData,
      required this.allFieldsFilled
  }) : super(key: key);

  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(mainLogoPath),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username/Email',
                  ),
                  onChanged: (value) => updateFormData('email', value),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  obscureText: true,
                  onChanged: (value) => updateFormData('password', value),
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: allFieldsFilled ? () => handleLogin(context) : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xfff5b342)
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetCredentialsScreen()),
                  );
                },
                child: Text(
                    'Forgot your Username or Password?',
                    style: TextStyle(
                      fontFamily: fontFamily,
                    ),
                  ),
              ),
              SizedBox(height: 10),
              Text(
                "Don't have an account?",
                style: TextStyle(
                  fontFamily: fontFamily,
                ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  'Register Here',
                  style: TextStyle(
                      fontFamily: fontFamily,
                    ),
                  ),
              ),
            ],
          ),
        );
  }
}
