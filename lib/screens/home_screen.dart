import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/hero_carousel.dart';
import 'package:flash_chat/screens/period_tracker_screen.dart';
import 'package:flash_chat/screens/profile_edit_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: StreamBuilder<User?>(
          // Use userChanges() instead of authStateChanges()
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data;

            return Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(user?.displayName ?? "User Name"),
                  accountEmail: Text(user?.email ?? "user@example.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: user?.photoURL != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(user!.photoURL!, fit: BoxFit.cover),
                          )
                        : Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Update Profile"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, ProfileEditScreen.id);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                  },
                ),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Carousel
              HeroCarousel(), // Using the Hero Carousel component
              SizedBox(height: 20),

              // Sectional Title
              Text(
                "Explore Features",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),

              // Period Tracker UI Card
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PeriodTrackerScreen.id);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Period Tracker",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Track your cycle with ease and get accurate predictions.",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
