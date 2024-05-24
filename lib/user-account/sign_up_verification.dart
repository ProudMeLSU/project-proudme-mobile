import 'package:flutter/material.dart';
import 'dart:convert';

import '../language.dart';

class SignUpVerificationScreen extends StatefulWidget {
  final String data;
  final String requiredCode;

  SignUpVerificationScreen({
    Key? key,
    required this.data,
    required this.requiredCode,
  }) : super(key: key);

  @override
  _SignUpVerificationScreenState createState() => _SignUpVerificationScreenState();
}

class _SignUpVerificationScreenState extends State<SignUpVerificationScreen> {
  Map<String, dynamic> formData = {
    'code': '',
  };

  bool allFieldsFilled = false;

  void updateFormData(String field, dynamic value) {
    setState(() {
      formData[field] = value;
      allFieldsFilled = formData.values.every((element) => element != '');
    });
  }

  void handleConfirm() {
    if (widget.requiredCode != formData['code']) {
       showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(confirmationErrorMessage),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
      
      return;
    }

    // Send an API request to signup with widget.data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          projectTitle,
          style: TextStyle(
            color: Color(0xfff5b342),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              confirmationPromptMessage,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirmation Code',
              ),
              onChanged: (value) => updateFormData('code', value),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: allFieldsFilled ? handleConfirm : null,
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                )
                ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xfff5b342)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
