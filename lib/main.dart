import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:st_teacher_app/Core/Utility/app_color.dart';

import 'Presentation/Home/home.dart';
import 'Presentation/Menu/menu_screen.dart';

void main() {
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
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColor.white),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
