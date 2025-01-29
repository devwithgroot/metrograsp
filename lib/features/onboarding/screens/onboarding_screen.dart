import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final TextEditingController _cycleLengthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Your Profile')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            // Save data to Firestore and navigate to dashboard
          }
        },
        steps: [
          Step(
            title: const Text('Personal Details'),
            content: Column(
              children: [
                TextFormField(decoration: const InputDecoration(labelText: 'Name')),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Cycle Length (days)'),
                  keyboardType: TextInputType.number,
                  controller: _cycleLengthController,
                ),
              ],
            ),
          ),
          const Step(
            title: Text('Health Preferences'),
            content: Text('Optional health questions...'),
          ),
          const Step(
            title: Text('Eco Preferences'),
            content: Text('Sustainable product interests...'),
          ),
        ],
      ),
    );
  }
}