import 'package:flutter/material.dart';
import 'features/period_tracker/screens/calendar_screen.dart'; // Add your home screen

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Period Tracker',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const CalendarScreen(), // Your initial screen
    );
  }
}