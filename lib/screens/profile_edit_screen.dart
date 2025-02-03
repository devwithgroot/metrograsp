import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> _updateProfile() async {
    setState(() => isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Update display name if changed
        if (_nameController.text.isNotEmpty && 
            _nameController.text != user.displayName) {
          await user.updateDisplayName(_nameController.text);
        }

        // Handle age update (if using Firestore or another database)
        if (_ageController.text.isNotEmpty) {
          updatedAge = _ageController.text;
          // Add Firestore update logic here if needed
        }

        // Reload the user to fetch the latest data
        await user.reload();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        // Optionally, navigate back to the previous screen
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: isLoading ? null : _updateProfile,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Update Profile'),
            ),
            if (updatedName != null || updatedAge != null)
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(top: 24.0),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (updatedAge != null)
                      Text(
                        'Updated Age: $updatedAge',
                        style: const TextStyle(
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