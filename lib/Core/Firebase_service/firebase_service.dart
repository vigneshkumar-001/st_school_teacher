// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:st_teacher_app/Core/consents.dart';
//
// import '../../Presentation/Login Screen/controller/login_controller.dart';
// import 'package:get/get.dart';
//
// class FirebaseService {
//   final LoginController controller = Get.put(LoginController());
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   final AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     'flutter_notification',
//     'flutter_notification_title',
//     importance: Importance.high,
//     enableLights: true,
//     showBadge: true,
//     playSound: true,
//   );
//
//   String? _fcmToken;
//   String? get fcmToken => _fcmToken;
//   @pragma('vm:entry-point')
//   Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     AppLogger.log.i('🔕 [BG] messageId=${message.messageId}');
//   }
//
//   Future<void> initializeFirebase() async {
//     // App already called Firebase.initializeApp() in main; safe to skip here.
//     // Register background handler ONCE (top-level function)
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//     // Android local notifications init
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidInit);
//     await flutterLocalNotificationsPlugin.initialize(initSettings);
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//
//     // Ask notification permission (Android 13+ & iOS)
//     await _requestNotificationPermission();
//   }
//
//   Future<void> _requestNotificationPermission() async {
//     final settings = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//     AppLogger.log.i(
//       '🔔 Notification permission: ${settings.authorizationStatus}',
//     );
//   }
//
//   Future<void> fetchFCMTokenIfNeeded() async {
//     final prefs = await SharedPreferences.getInstance();
//     _fcmToken = prefs.getString('fcmToken');
//
//     if (_fcmToken == null) {
//       final messaging = FirebaseMessaging.instance;
//       final token = await messaging.getToken();
//       AppLogger.log.i('✅ FCM Token: $token');
//       _fcmToken = token;
//       if (token != null) {
//         await prefs.setString('fcmToken', token);
//         controller.sendFcmToken(token);
//       }
//     } else {
//       controller.sendFcmToken(_fcmToken!);
//       AppLogger.log.i('ℹ️ Existing FCM Token: $_fcmToken');
//     }
//   }
//
//   Future<void> showNotification(RemoteMessage message) async {
//     const androidDetails = AndroidNotificationDetails(
//       'flutter_notification',
//       'flutter_notification_title',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const details = NotificationDetails(android: androidDetails);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       details,
//       payload: 'item x',
//     );
//   }
//
//   void listenToMessages({
//     required void Function(RemoteMessage) onMessage,
//     required void Function(RemoteMessage) onMessageOpenedApp,
//   }) {
//     FirebaseMessaging.onMessage.listen(onMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'package:st_teacher_app/Core/consents.dart';
import 'package:st_teacher_app/Presentation/Home/message_screen.dart';
import '../../Presentation/Login Screen/controller/login_controller.dart';

/// 🔹 Background message handler (MUST be top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AppLogger.log.i('🔕 [BG] messageId=${message.messageId}');
  AppLogger.log.i('🔕 [BG] New background message received!');
  AppLogger.log.i('📦 Message ID: ${message.messageId}');
  AppLogger.log.i('🔔 Title: ${message.notification?.title}');
  AppLogger.log.i('📝 Body: ${message.notification?.body}');
  AppLogger.log.i('💾 Data: ${message.data}');
  AppLogger.log.i('📱 From: ${message.from}');
}

class FirebaseService {
  final LoginController controller = Get.put(LoginController());
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'flutter_notification',
    'flutter_notification_title',
    description: 'Channel for high priority notifications',
    importance: Importance.high,
    enableLights: true,
    showBadge: true,
    playSound: true,
  );

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // 🔹 Initialize Firebase Messaging + Local Notifications
  Future<void> initializeFirebase() async {
    // Register background handler (must be done only once)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Android local notifications init
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    // Handle tap when notification received while app is in foreground
    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          _handleNotificationTap(payload);
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Ask notification permission (Android 13+ & iOS)
    await _requestNotificationPermission();
  }

  // 🔹 Ask for permission (Android 13+ & iOS)
  Future<void> _requestNotificationPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    AppLogger.log.i(
      '🔔 Notification permission: ${settings.authorizationStatus}',
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      AppLogger.log.w('🚫 User denied notification permission');
      Get.snackbar(
        'Notifications Disabled',
        'Please enable notifications in settings to stay updated.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // 🔹 Fetch and send FCM token
  Future<void> fetchFCMTokenIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    _fcmToken = prefs.getString('fcmToken');

    if (_fcmToken == null) {
      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();
      AppLogger.log.i('✅ New FCM Token: $token');
      _fcmToken = token;
      if (token != null) {
        await prefs.setString('fcmToken', token);
        controller.sendFcmToken(token);
      }
    } else {
      AppLogger.log.i('ℹ️ Existing FCM Token: $_fcmToken');
      controller.sendFcmToken(_fcmToken!);
    }

    // 🔁 Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      AppLogger.log.i('🔁 Token refreshed: $newToken');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcmToken', newToken);
      controller.sendFcmToken(newToken);
    });
  }

  // 🔹 Show local notification (for foreground)
  Future<void> showNotification(RemoteMessage message) async {
    final data = message.data;

    final androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    final details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      details,
      payload: data['screen'] ?? '', // pass route for navigation
    );
  }

  void listenToMessages({
    required void Function(RemoteMessage) onMessage,
    required void Function(RemoteMessage) onMessageOpenedApp,
  }) {
    // Foreground message
    FirebaseMessaging.onMessage.listen((msg) {
      AppLogger.log.i('📩 [FOREGROUND] Full Message Data:');
      _printFullMessage(msg);
      onMessage(msg);
    });

    // Background (app opened from notification)
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      AppLogger.log.i('📬 [OPENED FROM BG] Full Message Data:');
      _printFullMessage(msg);
      _handleNotificationTap(msg.data['screen']);
      onMessageOpenedApp(msg);
    });

    // Terminated (app launched from notification)
    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) {
        AppLogger.log.i('🚀 [TERMINATED TAP] Full Message Data:');
        _printFullMessage(msg);
        _handleNotificationTap(msg.data['screen']);
        onMessageOpenedApp(msg);
      }
    });
  }

  void _printFullMessage(RemoteMessage message) {
    AppLogger.log.i('🔔 Notification Title: ${message.notification?.title}');
    AppLogger.log.i('📝 Notification Body: ${message.notification?.body}');
    AppLogger.log.i('📦 Message ID: ${message.messageId}');
    AppLogger.log.i('📱 From: ${message.from}');
    AppLogger.log.i('⏰ Sent Time: ${message.sentTime}');
    AppLogger.log.i('🌐 Category: ${message.category}');
    AppLogger.log.i('🧩 Collapse Key: ${message.collapseKey}');
    AppLogger.log.i(
      '💾 Data Payload: ${message.data.isNotEmpty ? message.data : 'No data'}',
    );
  }

  void _handleNotificationTap(String? route) {
    if (route == null || route.isEmpty) return;

    switch (route) {
      case 'TeacherMessageDetails':
        Get.to(MessageScreen());
        break;
      case 'attendance':
        Get.toNamed('/attendance');
        break;
      default:
        AppLogger.log.i('⚠️ Unknown route: $route');
        break;
    }
  }
}
