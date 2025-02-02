import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for saving user data
import 'package:flash_chat/screens/user_details_screen.dart';  // Navigate to User Details screen
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';  // Modal progress HUD

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;  // FirebaseAuth instance
  bool showSpinner = false;  // To show a loading spinner during registration
  String? email;  // Email variable
  String? password;  // Password variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,  // Displaying the spinner during async call
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),  // Add your logo here
                  ),
                ),
              ),
              SizedBox(height: 48.0),
              TextField(
                keyboardType: TextInputType.emailAddress,  // Input type for email
                textAlign: TextAlign.center,  // Center the text
                onChanged: (value) {
                  email = value;  // Store the entered email
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
              ),
              SizedBox(height: 8.0),
              TextField(
                obscureText: true,  // Hide the password text
                textAlign: TextAlign.center,  // Center the password text
                onChanged: (value) {
                  password = value;  // Store the entered password
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(height: 24.0),
              Button(
                text: 'Register',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;  // Show spinner during registration attempt
                  });
                  try {
                    // Firebase registration method
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email!, password: password!);
                    if (newUser != null) {
                      // Navigate to User Details screen if registration is successful
                      Navigator.pushNamed(context, UserDetailsScreen.id);
                    }
                    setState(() {
                      showSpinner = false;  // Hide the spinner after registration attempt
                    });
                  } catch (e) {
                    print(e);  // Catch errors and print
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
