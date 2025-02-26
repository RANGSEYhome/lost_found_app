import 'package:flutter/material.dart';
import 'package:lost_found_app/modules/basic_module/basic_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Initialize local notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('💤 Background message received: ${message.notification?.title}');
}

// Show local notification
Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    details,
  );
}

// Setup push notifications
void setupPushNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions (for iOS)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // Get FCM token
  String? token = await messaging.getToken();
  print('FCM Token: $token');

  // Foreground message handling
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('🔔 Message received: ${message.notification?.title}');
    print('📄 Message body: ${message.notification?.body}');

    showNotification(message); // Show local notification
  });

  // Background message handling
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // When the app is opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🚀 Notification clicked!');
    print('📄 Message data: ${message.data}');
  });

  // Handle notification if app was launched by tapping the notification
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print('🏁 App launched by notification: ${initialMessage.notification?.title}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(android: androidInitSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  setupPushNotifications();
  runApp(providerBasicApp());
}
