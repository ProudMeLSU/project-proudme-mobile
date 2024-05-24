import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

import 'sign_up_verification.dart';
import '../constant.dart';
import '../language.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
Map<String, dynamic> formData = {
    'email': '',
    'password': '',
    'confirmPassword': '',
    'name': '',
    'firstName': '',
    'lastName': '',
    'schoolName': '',
    'birthMonth': '',
    'birthYear': '',
    'gradeLevel': '',
    'gender': '',
    'agreeToTerms': false,
    'agreeToAdUpdates': false,
  };

  bool allFieldsFilled = false;

  String generateRandomString(int length) {
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => charSets.codeUnitAt(random.nextInt(charSets.length))));
  }

  void updateFormData(String field, dynamic value) {
    setState(() {
      formData[field] = value;

      allFieldsFilled = formData.values.every((element) => element != '');
    });
  }

  Map<String, dynamic> getEmailParameters(String code) {
    Map<String, dynamic> emailParameters = {
      'subject': 'Project ProudMe Registration Confirmation',
      'to': formData['email'],
      'text': 'Hi ${formData['name']},\n\nYou are receiving this email because you recently registered a new account on the Project ProudMe webpage. \n\nEnter the confirmation code listed to confirm your email account: ${code}\n\nBest Regards, \nProject ProudMe Team \nLouisiana State University \nPedagogical Kinesiology Lab\n\n---\nThis email was sent from an account associated with Louisiana State University.',
    };

    return emailParameters;
  }

  void handleRegister() {
    String jsonData = jsonEncode(formData);
    String requiredCode = generateRandomString(8);
    
    Map<String, dynamic> emailParameters = getEmailParameters(requiredCode);
    // Call the send email API with email parameters

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpVerificationScreen(data: jsonData, requiredCode: requiredCode)),
    );
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
              fontFamily: fontFamily
            ),
          ),
          centerTitle: true,
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Image.asset(mainLogoPath),
            SizedBox(height: 20),
            Text(
              thankYouMessage,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              onChanged: (value) => updateFormData('name', value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              onChanged: (value) => updateFormData('password', value),
              obscureText: true,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              onChanged: (value) => updateFormData('confirmPassword', value),
              obscureText: true,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'First Name'),
              onChanged: (value) => updateFormData('firstName', value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Last Name'),
              onChanged: (value) => updateFormData('lastName', value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'School Attending'),
              onChanged: (value) => updateFormData('schoolName', value),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Birth Month'),
              onChanged: (value) => updateFormData('birthMonth', value),
              items: months.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Birth Year'),
              onChanged: (value) => updateFormData('birthYear', value),
              items: List.generate(
                11,
                (index) => DropdownMenuItem<int>(
                  value: 2008 + index,
                  child: Text((2008 + index).toString()),
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Grade Level'),
              onChanged: (value) => updateFormData('gradeLevel', value),
              items: grades.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Gender'),
              onChanged: (value) => updateFormData('gender', value),
              items: genders.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => updateFormData('email', value),
            ),
            Row(
              children: [
                Checkbox(
                  value: formData['agreeToTerms'],
                  onChanged: (bool? value) {
                    updateFormData('agreeToTerms', value);
                  },
                ),
                Text(
                  serviceAgreement,
                  style: TextStyle(
                    fontFamily: fontFamily
                  )
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: formData['agreeToAdUpdates'],
                  onChanged: (bool? value) {
                    updateFormData('agreeToAdUpdates', value);
                  },
                ),
                Text(
                  adsAgreement,
                  style: TextStyle(
                    fontFamily: fontFamily
                  )
                ),
              ],
            ),
            ElevatedButton(
              onPressed: allFieldsFilled ? handleRegister : null,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xfff5b342),
                  ),
              ),
              child: Text(
                'Register',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: fontFamily
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
