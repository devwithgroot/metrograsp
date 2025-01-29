import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metrograsp/features/auth/providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.read<AuthProvider>().signInWithGoogle(context),
              child: const Text('Sign In with Google'),
            ),
            const SizedBox(height: 20),
            const Text('OR'),
            const SizedBox(height: 20),
            // Add email/password form here
          ],
        ),
      ),
    );
  }
}