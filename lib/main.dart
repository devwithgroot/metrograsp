import 'package:flash_chat/screens/home_screen.dart';
import 'package:flash_chat/screens/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';// Your registration screen
import 'package:flash_chat/screens/period_tracker_screen.dart';  // Your period tracker screen
import 'package:flash_chat/screens/user_details_screen.dart'; // Import the UserDetailsScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(PeriodTrackerApp()); // Changed the app name to PeriodTrackerApp
}

class PeriodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id, // Entry point is the WelcomeScreen
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PeriodTrackerScreen.id: (context) => PeriodTrackerScreen(),
        UserDetailsScreen.id: (context) => UserDetailsScreen(),  // Register UserDetailsScreen route
        HomeScreen.id: (context) => HomeScreen(),// Added PeriodTrackerScreen
        ProfileEditScreen.id: (context) => ProfileEditScreen(),
      },
    );
  }
}
