import 'package:flutter/material.dart';

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
  final Map<String, dynamic> _formData = {
    'code': '',
  };

  bool allFieldsFilled = false;

  void updateFormData(String field, dynamic value) {
    setState(() {
      _formData[field] = value;
      allFieldsFilled = _formData.values.every((element) => element != '');
    });
  }

  void handleConfirm() {
    if (widget.requiredCode != _formData['code']) {
       showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text(confirmationErrorMessage),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
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
        title: const Text(
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
            const Text(
              confirmationPromptMessage,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Confirmation Code',
              ),
              onChanged: (value) => updateFormData('code', value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: allFieldsFilled ? handleConfirm : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xfff5b342)
                ),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                )
                ),
            ),
          ],
        ),
      ),
    );
  }
}
