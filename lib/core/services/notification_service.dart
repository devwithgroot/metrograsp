import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permissions
    await _firebaseMessaging.requestPermission();

    // Setup local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Listen for messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  void _showNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'period_channel',
      'Period Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }

  // Schedule period reminder (call this when cycle is logged)
  Future<void> schedulePeriodReminder(DateTime predictedDate) async {
    await _firebaseMessaging.subscribeToTopic('period_reminders');
    // Use Firebase Cloud Functions to schedule FCM at predictedDate - 3 days
  }
}