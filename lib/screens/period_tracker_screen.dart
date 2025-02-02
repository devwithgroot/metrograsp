import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/notification_service.dart';

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
  bool dataCalculated = false; // New flag to control card rendering

  final _firestore = FirebaseFirestore.instance;

  void calculateDates() {
    if (lastPeriodDate != null && cycleLength != null && cycleLength! > 2) {
      // Calculate dates based on user input
      nextPeriodDate = lastPeriodDate!.add(Duration(days: cycleLength!));
      ovulationDate = nextPeriodDate!.subtract(Duration(days: 14));
      fertileStart = ovulationDate!.subtract(Duration(days: 5));
      fertileEnd = ovulationDate!.add(Duration(days: 1));
      pmsStart = nextPeriodDate!.subtract(Duration(days: 7));
      pmsEnd = nextPeriodDate!.subtract(Duration(days: 5));

      if (shortestCycleLength != null && longestCycleLength != null) {
        averageCycleLength = (shortestCycleLength! + longestCycleLength!) / 2;
        int range = longestCycleLength! - shortestCycleLength!;
        cycleRegularity = range > 7 ? 'Irregular Cycle' : 'Regular Cycle';
      }

      bestConceptionStart = ovulationDate!.subtract(Duration(days: 2));
      bestConceptionEnd = ovulationDate;
    }
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required Color color,
    required IconData icon,
    String? subtitle,
    Widget? chart,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Circular icon background for a modern touch
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            if (chart != null) ...[
              SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: chart,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lastPeriodDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      cancelText: 'Cancel', // Label for the Cancel button
      confirmText: 'OK',    // Label for the Confirm button
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                side: BorderSide(color: Colors.white), // White border
                foregroundColor: Colors.deepPurple,     // Text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        lastPeriodDate = picked;
      });
    }
  }

  Future<void> saveData() async {
  if (lastPeriodDate == null || cycleLength == null || cycleLength! < 3) {
    _showErrorDialog("Enter a valid cycle length (at least 3 days).");
    return;
  }

  setState(() {
    isLoading = true;
    dataCalculated = false; // Reset flag on new submission
  });

  try {
    // Perform the calculations
    calculateDates();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Schedule the notification for the next period date.
      // You can adjust the scheduled time (e.g., notify at 9 AM on the next period date)
      await NotificationService().scheduleNotification(
        id: 0,
        title: 'Period Reminder',
        body: 'Your next period is expected on ${DateFormat('MMM dd, yyyy').format(nextPeriodDate!)}',
        scheduledDate: nextPeriodDate!,
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving data: $e'),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() {
      isLoading = false;
      dataCalculated = true; // Mark that the calculation and saving are complete
    });
  }
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.black87)),
        content: Text(message, style: TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.deepPurple)),
          ),
        ],
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Period Tracker', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Input Card with modern styling
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Your Cycle Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Last Period Date',
                        hintText: 'Tap to select date',
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.deepPurple),
                      ),
                      controller: TextEditingController(
                        text: lastPeriodDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(lastPeriodDate!),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        cycleLength = int.tryParse(value);
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Cycle Length',
                        hintText: 'Enter days',
                        prefixIcon: Icon(Icons.access_time, color: Colors.deepPurple),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        shortestCycleLength = int.tryParse(value);
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Shortest Cycle Length',
                        hintText: 'Enter days',
                        prefixIcon: Icon(Icons.arrow_downward, color: Colors.deepPurple),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        longestCycleLength = int.tryParse(value);
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Longest Cycle Length',
                        hintText: 'Enter days',
                        prefixIcon: Icon(Icons.arrow_upward, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Only display info cards after the saving process is complete
            if (dataCalculated)
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildInfoCard(
                    title: 'Next Period',
                    content: DateFormat('MMM dd, yyyy').format(nextPeriodDate!),
                    color: Colors.deepPurple,
                    icon: Icons.calendar_today,
                    subtitle: 'Upcoming',
                  ),
                  _buildInfoCard(
                    title: 'Ovulation',
                    content: DateFormat('MMM dd, yyyy').format(ovulationDate!),
                    color: Colors.red,
                    icon: Icons.favorite,
                  ),
                  _buildInfoCard(
                    title: 'Fertile Window',
                    content:
                        '${DateFormat('MMM dd').format(fertileStart!)} - ${DateFormat('MMM dd').format(fertileEnd!)}',
                    color: Colors.pink,
                    icon: Icons.favorite_border,
                  ),
                  _buildInfoCard(
                    title: 'PMS Window',
                    content:
                        '${DateFormat('MMM dd').format(pmsStart!)} - ${DateFormat('MMM dd').format(pmsEnd!)}',
                    color: Colors.orange,
                    icon: Icons.warning_amber_rounded,
                  ),
                  _buildInfoCard(
                    title: 'Cycle Status',
                    content: cycleRegularity,
                    color: Colors.blue,
                    icon: Icons.analytics,
                    subtitle: 'Based on your history',
                  ),
                  _buildInfoCard(
                    title: 'Conception Days',
                    content:
                        '${DateFormat('MMM dd').format(bestConceptionStart!)} - ${DateFormat('MMM dd').format(bestConceptionEnd!)}',
                    color: Colors.teal,
                    icon: Icons.child_friendly,
                  ),
                ],
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      saveData();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Calculate & Save',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
