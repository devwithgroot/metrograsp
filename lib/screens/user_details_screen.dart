import 'package:cloud_firestore/cloud_firestore.dart';  // Firestore package to save data
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';  // Constants for decoration
import 'package:flash_chat/screens/home_screen.dart';  // Navigate to Home Screen

class UserDetailsScreen extends StatefulWidget {
  static const String id = 'user_details_screen';

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String? name;
  int? age;
  int? cycleLength;
  DateTime? lastPeriodDate;
  bool isLoading = false;

  final _firestore = FirebaseFirestore.instance;  // Firestore instance

  // Form submission handler
  void submitDetails() async {
    if (name != null && age != null && cycleLength != null && lastPeriodDate != null) {
      setState(() {
        isLoading = true;  // Show loading while saving data
      });

      try {
        final user = FirebaseAuth.instance.currentUser;  // Get current user
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'name': name,
            'age': age,
            'cycleLength': cycleLength,
            'lastPeriodDate': lastPeriodDate,
            'email': user.email,
          });

          // After saving data, navigate to the Home Screen
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      } catch (e) {
        print(e);  // Catch errors and print
      } finally {
        setState(() {
          isLoading = false;  // Hide loading after operation
        });
      }
    } else {
      // Show an alert if fields are missing
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Missing Information'),
          content: Text('Please fill out all fields.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Details')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                name = value;  // Store name
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Name'),
            ),
            SizedBox(height: 8.0),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                age = int.tryParse(value);  // Store age as integer
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Age'),
            ),
            SizedBox(height: 8.0),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                cycleLength = int.tryParse(value);  // Store cycle length as integer
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Cycle Length'),
            ),
            SizedBox(height: 8.0),
            TextField(
              onChanged: (value) {
                try {
                  lastPeriodDate = DateTime.parse(value);  // Parse and store last period date
                } catch (e) {
                  lastPeriodDate = null;
                }
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Last Period Date (yyyy-mm-dd)'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : submitDetails,  // Disable button while loading
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
