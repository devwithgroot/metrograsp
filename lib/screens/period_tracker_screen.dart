import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flash_chat/constants.dart'; // UI styling
import 'package:firebase_auth/firebase_auth.dart'; // Firebase authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore database

class PeriodTrackerScreen extends StatefulWidget {
  static const String id = 'period_tracker_screen';

  @override
  _PeriodTrackerScreenState createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  DateTime? lastPeriodDate;
  int? cycleLength;
  int? shortestCycleLength;
  int? longestCycleLength;
  double? averageCycleLength;
  DateTime? nextPeriodDate;
  DateTime? ovulationDate;
  DateTime? fertileStart;
  DateTime? fertileEnd;
  DateTime? pmsStart;
  DateTime? pmsEnd;
  String cycleRegularity = '';
  DateTime? bestConceptionStart;
  DateTime? bestConceptionEnd;
  bool isLoading = false;

  final _firestore = FirebaseFirestore.instance;

  // 🛠 **Calculate Next Period & Ovulation Dates**
  void calculateDates() {
    if (lastPeriodDate != null && cycleLength != null && cycleLength! > 2) {
      setState(() {
        // ✅ Next Period Date Calculation
        nextPeriodDate = lastPeriodDate!.add(Duration(days: cycleLength!));

        // ✅ Ovulation Window (14 Days Before Next Period)
        ovulationDate = nextPeriodDate!.subtract(Duration(days: 14));

        // ✅ Fertile Window (5 Days Before Ovulation + Ovulation Day)
        fertileStart = ovulationDate!.subtract(Duration(days: 5));
        fertileEnd = ovulationDate!.add(Duration(days: 1));

        // ✅ PMS Prediction (5-7 Days Before Period)
        pmsStart = nextPeriodDate!.subtract(Duration(days: 7));
        pmsEnd = nextPeriodDate!.subtract(Duration(days: 5));

        // ✅ Cycle Regularity Analysis
        if (shortestCycleLength != null && longestCycleLength != null) {
          averageCycleLength = (shortestCycleLength! + longestCycleLength!) / 2;
          int range = longestCycleLength! - shortestCycleLength!;
          if (range > 7) {
            cycleRegularity = 'Irregular Cycle';
          } else {
            cycleRegularity = 'Regular Cycle';
          }
        }

        // ✅ Best Days for Conception (2 Days Before Ovulation + Ovulation Day)
        bestConceptionStart = ovulationDate!.subtract(Duration(days: 2));
        bestConceptionEnd = ovulationDate;
      });
    }
  }

  // 📌 **Save Data to Firestore**
  void saveData() async {
    if (lastPeriodDate == null || cycleLength == null || cycleLength! < 3) {
      _showErrorDialog("Enter a valid cycle length (at least 3 days).");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'lastPeriodDate': lastPeriodDate!.toIso8601String(),
          'cycleLength': cycleLength,
          'nextPeriodDate': nextPeriodDate!.toIso8601String(),
          'ovulationDate': ovulationDate!.toIso8601String(),
          'fertileStart': fertileStart!.toIso8601String(),
          'fertileEnd': fertileEnd!.toIso8601String(),
          'pmsStart': pmsStart!.toIso8601String(),
          'pmsEnd': pmsEnd!.toIso8601String(),
          'cycleRegularity': cycleRegularity,
          'bestConceptionStart': bestConceptionStart!.toIso8601String(),
          'bestConceptionEnd': bestConceptionEnd!.toIso8601String(),
        });
      }
    } catch (e) {
      print('Error saving data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 📆 **Date Picker for Last Period Date**
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lastPeriodDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        lastPeriodDate = picked;
      });
    }
  }

  // ⚠ **Error Dialog**
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Period Tracker')),
      body: SingleChildScrollView( // Wrapping everything in a scroll view
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 📆 **Last Period Date Input**
            TextField(
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Tap to select your last period date',
              ),
              controller: TextEditingController(
                text: lastPeriodDate == null
                    ? ''
                    : DateFormat('yyyy-MM-dd').format(lastPeriodDate!),
              ),
            ),
            SizedBox(height: 8.0),

            // 🔢 **Cycle Length Input**
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                cycleLength = int.tryParse(value);
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your cycle length (days)',
              ),
            ),
            SizedBox(height: 16.0),

            // 🔢 **Cycle Length Range Input**
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                shortestCycleLength = int.tryParse(value);
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your shortest cycle length (days)',
              ),
            ),
            SizedBox(height: 8.0),

            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                longestCycleLength = int.tryParse(value);
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your longest cycle length (days)',
              ),
            ),
            SizedBox(height: 16.0),

            // 📊 **Show Calculated Dates**
            if (nextPeriodDate != null)
              Text(
                '📅 Next Period Date: ${DateFormat('yyyy-MM-dd').format(nextPeriodDate!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (ovulationDate != null)
              Text(
                '🩸 Ovulation Date: ${DateFormat('yyyy-MM-dd').format(ovulationDate!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (fertileStart != null && fertileEnd != null)
              Text(
                '💖 Fertile Window: ${DateFormat('yyyy-MM-dd').format(fertileStart!)} to ${DateFormat('yyyy-MM-dd').format(fertileEnd!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (pmsStart != null && pmsEnd != null)
              Text(
                '⚠ PMS Prediction: ${DateFormat('yyyy-MM-dd').format(pmsStart!)} to ${DateFormat('yyyy-MM-dd').format(pmsEnd!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (cycleRegularity.isNotEmpty)
              Text(
                '📊 Cycle Regularity: $cycleRegularity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (bestConceptionStart != null && bestConceptionEnd != null)
              Text(
                '👶 Best Days for Conception: ${DateFormat('yyyy-MM-dd').format(bestConceptionStart!)} to ${DateFormat('yyyy-MM-dd').format(bestConceptionEnd!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 24.0),

            // ✅ **Save & Set Reminder Button**
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                calculateDates();
                saveData();
              },
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Save & Set Reminders'),
            ),
          ],
        ),
      ),
    );
  }
}
