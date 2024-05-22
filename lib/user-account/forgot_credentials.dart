import 'package:flutter/material.dart';
import 'dart:convert';

class ForgetCredentialsScreen extends StatefulWidget {
  @override
  _ForgetCredentialsScreenState createState() => _ForgetCredentialsScreenState();
}

class _ForgetCredentialsScreenState extends State<ForgetCredentialsScreen> {
  bool _resetPassword = true;

  Map<String, dynamic> formData = {
    'email': '',
  };

  bool allFieldsFilled = false;

  void updateFormData(String field, dynamic value) {
    setState(() {
      formData[field] = value;

      allFieldsFilled = formData.values.every((element) => element != '');
    });
  }

  void handleAction() {
    String jsonData = jsonEncode(formData);
    print(jsonData);

    if (_resetPassword) {
      resetPassword();
    } else {
      recoverUsername();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Proud Me',
          style: TextStyle(
            color: Color(0xfff5b342),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Forgot Your Username or Password?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Email',
              ),
              onChanged: (value) => updateFormData('email', value),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Switch(
                  value: _resetPassword,
                  onChanged: (bool value) {
                    setState(() {
                      _resetPassword = value;
                    });
                  },
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Recover username/Reset password"),
                        content: Text("Use this toggle button to switch between recover username or reset password functionality."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Icon(Icons.info),
                ),
                Text(_resetPassword ? 'Reset Password' : 'Recover Username'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: allFieldsFilled ? handleAction : null,
              child: _resetPassword ? Text('Reset Password') : Text('Recover Username'),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword() {
    print('Reset Password');
  }

  void recoverUsername() {
    print('Recover Username');
  }
}
