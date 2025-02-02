import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Firebase Authentication

class ProfileEditScreen extends StatefulWidget {
  static const String id = 'profile_edit_screen';

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String? updatedName;
  String? updatedAge;

  // Function to update profile
  void updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (_nameController.text.isNotEmpty) {
          await user.updateDisplayName(_nameController.text);
        }

        // Saving age in Firestore (you could also save it in the user's profile if needed)
        if (_ageController.text.isNotEmpty) {
          updatedAge = _ageController.text;  // Save the updated age
          // Optionally save age to Firestore (e.g. firestore.collection('users').doc(user.uid).update({'age': updatedAge}));
        }

        await user.reload(); // Refresh user details
        final updatedUser = _auth.currentUser;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        setState(() {
          updatedName = updatedUser?.displayName ?? _nameController.text;
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Profile')),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                updateProfile();
              },
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Update Profile'),
            ),
            SizedBox(height: 24.0),

            // Display updated profile information below
            if (updatedName != null || updatedAge != null)
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (updatedName != null)
                      Text(
                        'Updated Name: $updatedName',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (updatedAge != null)
                      Text(
                        'Updated Age: $updatedAge',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
