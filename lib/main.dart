import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:st_teacher_app/Core/Utility/app_color.dart';
import 'package:st_teacher_app/splash_screen.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'Core/Firebase_service/firebase_service.dart';
import 'init_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final firebaseService = FirebaseService();
  await firebaseService.initializeFirebase();
  await firebaseService.fetchFCMTokenIfNeeded();

  // (Optional) foreground/opened handlers
  firebaseService.listenToMessages(
    onMessage: (msg) {
      AppLogger.log.i('📩 [FG] ${msg.messageId}');
      firebaseService.showNotification(msg);
    },
    onMessageOpenedApp: (msg) {
      AppLogger.log.i('📬 [OPENED] ${msg.messageId}');
    },
  );

  await initController();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColor.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColor.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColor.lowLightgray),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
