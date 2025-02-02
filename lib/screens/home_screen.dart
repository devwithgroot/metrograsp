// import 'package:flutter/material.dart';
// import 'package:flash_chat/screens/period_tracker_screen.dart';  // Import Period Tracker Screen
//
// class HomeScreen extends StatelessWidget {
//   static const String id = 'home_screen';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Welcome to Period Tracker')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Home Screen - Period Tracker App',
//               style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20.0),
//             // Button to navigate to Period Tracker Screen
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, PeriodTrackerScreen.id); // Navigate to Period Tracker Screen
//               },
//               child: Text('Period Tracking'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.lightBlueAccent,
//                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flash_chat/screens/period_tracker_screen.dart';  // Import Period Tracker Screen
import 'package:flash_chat/screens/profile_edit_screen.dart';    // Import Profile Edit Screen

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Period Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home Screen - Period Tracker App',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            // Button to navigate to Period Tracker Screen
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, PeriodTrackerScreen.id); // Navigate to Period Tracker Screen
              },
              child: Text('Period Tracking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20.0),
            // Button to navigate to Profile Edit Screen
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfileEditScreen.id); // Navigate to Profile Edit Screen
              },
              child: Text('Update Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
