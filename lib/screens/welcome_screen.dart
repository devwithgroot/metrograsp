import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Slide-up animation
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.25), // Start 25% down
      end: Offset.zero, // End at original position
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuart,
      ),
    );

    // Fade-in animation
    _fadeAnimation = Tween<double>(
      begin: 0, // Start fully transparent
      end: 1, // End fully visible
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            SizedBox(height: 70),

            // Animated Hero Text
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Period Companion',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 16),

            // Subtitle with fade animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Empower your health journey with\nsmart cycle tracking and insights',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple[600],
                  height: 1.4,
                ),
              ),
            ),

            // 3D Illustration Space
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Image.asset(
                  'assets/period_illustration.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Bottom Buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  text: 'Log In',
                  color: Colors.deepPurple,
                  onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                ),
                SizedBox(height: 8),
                Button(
                  text: 'Register',
                  color: Colors.purple[300]!,
                  onPressed: () => Navigator.pushNamed(context, RegistrationScreen.id),
                ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}