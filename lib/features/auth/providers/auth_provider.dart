import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:metrograsp/core/services/auth_service.dart';
import '../models/user_model.dart';
import 'package:metrograsp/features/onboarding/screens/onboarding_screen.dart';
import 'package:metrograsp/features/period_tracker/screens/calendar_screen.dart'; // Add CalendarScreen import

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  AppUser? _user;

  AuthProvider(this._authService);

  AppUser? get user => _user;

  User? get currentUser => _authService.currentUser;

  Future<void> checkAuthState() async {
    final User? firebaseUser = currentUser;
    if (firebaseUser != null) {
      _user = await _fetchUserData(firebaseUser.uid);
    }
    notifyListeners();
  }

  // Add the missing _fetchUserData method
  Future<AppUser?> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final User? firebaseUser = await _authService.signInWithGoogle();
      if (firebaseUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) {
          await _createNewUser(firebaseUser);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const CalendarScreen()),
          );
        }
        _user = await _fetchUserData(firebaseUser.uid);
        notifyListeners();
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  Future<void> _createNewUser(User firebaseUser) async {
    await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
      'id': firebaseUser.uid,
      'email': firebaseUser.email,
      'name': firebaseUser.displayName ?? 'User',
      'cycleLength': 28,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}