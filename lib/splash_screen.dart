import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_teacher_app/Presentation/Announcement%20Screen/controller/announcement_contorller.dart';
import 'package:st_teacher_app/Presentation/Login%20Screen/controller/login_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Core/Utility/app_color.dart';
import 'Core/Utility/app_images.dart';
import 'Core/Utility/custom_app_button.dart';
import 'Core/Utility/google_fonts.dart';
import 'Presentation/Home/home.dart';
import 'Presentation/Home/home_new_screen.dart';
import 'Presentation/Homework/controller/teacher_class_controller.dart';
import 'Presentation/Login Screen/change_mobile_number.dart';
import 'package:get/get.dart';

import 'Presentation/Profile/controller/teacher_data_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _progress = 0.0;

  final TeacherClassController controller = Get.put(TeacherClassController());
  final TeacherDataController imgData = Get.put(TeacherDataController());
  final AnnouncementContorller announcementContorller = Get.put(
    AnnouncementContorller(),
  );
  final LoginController loginController = Get.put(LoginController());
  final String latestVersion = "2.3.1";


  @override
  void initState() {
    super.initState();

    // Animation controller for 12 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addListener(() {
      setState(() {
        _progress = _controller.value; // 0.0 -> 1.0
      });
    });

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      _checkAppVersion();
    });
  }

  //new
/*  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // very fast
    );

    _controller.addListener(() {
      setState(() {
        _progress = _controller.value;
      });
    });

    _waitForDataAndNavigate();
  }*/

  Future<void> _waitForDataAndNavigate() async {
    // Wait until teacher data is loaded
    while (imgData.teacherDataResponse.value == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    // Animate progress to full quickly
    _controller.forward(from: _progress).then((_) {
      _checkAppVersion(); // Check version & move to next screen immediately
    });
  }


  Future<void> _checkAppVersion() async {
    // Try to read version from API data
    final currentVersion =
        imgData
            .teacherDataResponse
            .value
            ?.data
            ?.appVersions
            ?.android
            ?.latestVersion
            ?.toString();

    // Case 1: If token not present → API didn’t load → skip version check
    if (currentVersion == null || currentVersion.isEmpty) {
      _checkLoginStatus(); // Go to login flow
      return;
    }

    if (currentVersion == latestVersion) {
      _checkLoginStatus(); // Go to home or login based on token
    } else {
      // Case 3: Version mismatch → show update bottom sheet
      _showUpdateBottomSheet();
    }
  }

  // void _checkLoginStatus() async {
  //   final isLoggedIn = await loginController.isLoggedIn();
  //   if (isLoggedIn) {
  //     // Skip splash and go to Home
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => Home(page: 'homeScreen')),
  //     );
  //   } else {
  //     // First time user → continue splash
  //     controller.getTeacherClass();
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       announcementContorller.getCategoryList(showLoader: false);
  //       imgData.getTeacherClassData();
  //     });
  //     _startLoading();
  //   }
  // }

  void _checkLoginStatus() async {
    final isLoggedIn = await loginController.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeNewScreen(page: 'homeScreen'),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeMobileNumber(page: 'splash'),
        ),
      );
    }
  }

  void _showUpdateBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Update Available",
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                "A new version of the app is available. Please update to continue.",
                textAlign: TextAlign.center,
                style: GoogleFonts.ibmPlexSans(fontSize: 14),
              ),
              const SizedBox(height: 24),
              AppButton.button(
                text: 'Update Now',
                onTap: () {
                  openPlayStore();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void openPlayStore() async {
    final storeUrl =
        imgData.teacherDataResponse.value?.data.appVersions.android.storeUrl
            .toString() ??
        '';

    if (storeUrl.isEmpty) {
      print('No URL available.');
      return;
    }

    final uri = Uri.parse(storeUrl);
    print('Trying to launch: $uri');

    // Try in-app or platform default mode
    final success = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault, // or LaunchMode.inAppWebView
    );

    if (!success) {
      print('Could not open the link. Maybe no browser is installed.');
    }
  }

  // void openPlayStore() async {
  //   final storeUrl =
  //       imgData.teacherDataResponse.value?.data.appVersions.android.storeUrl
  //           .toString() ??
  //           '';
  //
  //   if (storeUrl.isEmpty) {
  //     print('No Play Store URL available.');
  //     return;
  //   }
  //
  //   final uri = Uri.parse(storeUrl);
  //
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     print('Could not open the Play Store link.');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AppImages.splashBackImage1),
                        Image.asset(AppImages.schoolLogo1),
                        Image.asset(AppImages.splashBackImage2),
                        SizedBox(height: 10),
                        Container(
                          width: width,
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColor.blueG2,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  Container(color: AppColor.white),
                                  FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor:
                                        _progress, // updated with controller
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColor.blueG1,
                                            AppColor.blueG2,
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        Text(
                          'V $latestVersion',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColor.lightgray,
                          ),
                        ),
                      ],
                    ),

                    Positioned(
                      bottom: 120,
                      left: 0,
                      right: 0,
                      child: Text(
                        'For Teachers',
                        textAlign: TextAlign.center,
                        style: GoogleFont.ibmPlexSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
