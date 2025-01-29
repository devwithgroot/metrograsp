import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/period_tracker/screens/calendar_screen.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metrograsp',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check auth state on startup
    Future.delayed(Duration.zero, () async {
      await authProvider.checkAuthState();
      if (authProvider.user == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CalendarScreen()));
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}