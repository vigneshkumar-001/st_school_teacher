import 'package:flutter/material.dart';
import 'package:st_teacher_app/Core/Utility/app_color.dart';
import 'package:st_teacher_app/Core/Utility/app_images.dart';

import '../../Core/Utility/google_fonts.dart';
import '../Menu/menu_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blue,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(AppImages.homescreenBcImage),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 8,
                              ),
                              child: Image.asset(
                                AppImages.schoolLogo,
                                height: 33,
                                width: 29.4,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Menu',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 7),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(11.0),
                                child: Image.asset(
                                  AppImages.menuImage,
                                  height: 23.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Greeting
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning',
                            style: GoogleFont.ibmPlexSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: AppColor.white,
                            ),
                          ),
                          Text(
                            'Megha!',
                            style: GoogleFont.ibmPlexSans(
                              fontWeight: FontWeight.w900,
                              fontSize: 33,
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            DraggableScrollableSheet(
              initialChildSize: 0.40,
              minChildSize: 0.40,
              maxChildSize: 0.99,
              builder: (context, _) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const Text(
                        'Expanded White Sheet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Add static widgets (no scroll)
                      const Text('This sheet expands but doesn’t scroll.'),
                      const SizedBox(height: 20),
                      const Text('Add your static widgets here.'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Click Me'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
