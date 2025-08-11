import 'dart:async';

import 'package:flutter/material.dart';

import '../Core/Utility/app_color.dart';
import 'Core/Utility/app_images.dart';
import 'Core/Utility/google_fonts.dart';
import 'Presentation/Login Screen/change_mobile_number.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        _progress += 0.1; // Increase progress
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeMobileNumber(page: 'splash'),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AppImages.splashBackImage1),
                        Image.asset(AppImages.schoolLogo1),
                        Image.asset(AppImages.splashBackImage2),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    top: 640,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'For Teachers',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                width: width,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColor.blue, width: 2),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: _progress),
                      duration: Duration(milliseconds: 500),
                      builder: (context, value, _) {
                        return Stack(
                          children: [
                            Container(color: AppColor.white),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [AppColor.blueG1, AppColor.blue],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 35),

              Text(
                'V 1.2',
                style: GoogleFont.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightgray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
