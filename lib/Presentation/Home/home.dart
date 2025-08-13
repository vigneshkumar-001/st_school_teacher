import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:st_teacher_app/Core/Utility/app_color.dart';
import 'package:st_teacher_app/Core/Utility/app_images.dart';
import 'package:flutter/material.dart' hide CarouselController;

import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Attendance/attendance_history_student.dart';
import '../Attendance/attendance_start.dart';
import '../Menu/menu_screen.dart';

class Home extends StatefulWidget {
  final String? pages;
  const Home({super.key, this.pages, required String page});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int selectedIndex = 0;
  int subjectIndex = 0;
  bool showThirdContainer = false;

  final List<Map<String, String>> classData = [
    {'grade': '8', 'section': 'A'},
    {'grade': '8', 'section': 'B'},
    {'grade': '8', 'section': 'C'},
    {'grade': '9', 'section': 'A'},
    {'grade': '9', 'section': 'C'},
  ];

  final List<Map<String, dynamic>> sliderItems = [
    {
      'gradient': LinearGradient(
        colors: [
          AppColor.bluehG1,
          AppColor.bluehG1,
          AppColor.bluehG1,

          AppColor.bluehG2.withOpacity(0.5),
          AppColor.white.withOpacity(0.5),
          AppColor.white,
          AppColor.white,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      'mainText1': 'Conduct',
      'mainText2': 'Quiz',
      'iconImage': AppImages.Quiz,
      'bcImage': AppImages.bcImage,
      'iconHeight': 90,
      'iconWidth': 90,
    },
    {
      'gradient': LinearGradient(
        colors: [
          AppColor.greenG1,
          AppColor.greenG1,
          AppColor.greenG1.withOpacity(0.9),
          AppColor.greenG2.withOpacity(0.5),
          AppColor.greenG3.withOpacity(0.5),
          AppColor.white.withOpacity(0.5),
          AppColor.white,
          AppColor.white,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      'mainText1': 'Assign',
      'mainText2': 'Homework',
      'iconImage': AppImages.Homework,
      'bcImage': AppImages.bcImage,
      'iconHeight': 110,
      'iconWidth': 100,
    },

    {
      'gradient': LinearGradient(
        colors: [
          AppColor.orangeG1,
          AppColor.orangeG1,
          AppColor.orangeG1,
          AppColor.orangeG2.withOpacity(0.5),
          AppColor.white.withOpacity(0.5),
          AppColor.white,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      'mainText1': 'Schedule',
      'mainText2': 'Exam',
      'iconImage': AppImages.scheduleExam,
      'bcImage': AppImages.bcImage,
      'iconHeight': 90,
      'iconWidth': 85,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double itemHeight = 210;
    final double itemWidth = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
      backgroundColor: AppColor.blue,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset(AppImages.homescreenBcImage),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                Spacer(),
                                Text(
                                  'Menu',
                                  style: GoogleFont.ibmPlexSans(
                                    fontSize: 14,
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 7),
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

                          SizedBox(height: 35),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
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
                  Stack(
                    children: [
                      Positioned(
                        top: 140,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: DraggableScrollableSheet(
                          initialChildSize: 0.85,
                          minChildSize: 0.85,
                          maxChildSize: 0.85,
                          builder: (context, scrollController) {
                            return Container(
                              padding: const EdgeInsets.all(0),
                              decoration: const BoxDecoration(
                                color: AppColor.white,
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
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  child: Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Actions',
                                          style: GoogleFont.ibmPlexSans(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 20),

                                        CarouselSlider(
                                          options: CarouselOptions(
                                            height: 235,
                                            enlargeCenterPage: true,
                                            enlargeFactor: 0.4,
                                            viewportFraction: 0.4,

                                            autoPlayInterval: const Duration(
                                              seconds: 3,
                                            ),
                                            scrollPhysics:
                                                BouncingScrollPhysics(),
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                _currentIndex = index;
                                              });
                                            },
                                          ),
                                          items:
                                              sliderItems.map((item) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 0.0,
                                                      ),
                                                  child: CommonContainer.carouselSlider(
                                                    mainText1:
                                                        item['mainText1'],
                                                    mainText2:
                                                        item['mainText2'],
                                                    iconImage:
                                                        item['iconImage'],
                                                    bcImage: item['bcImage'],
                                                    gradient: item['gradient'],
                                                    iconHeight:
                                                        (item['iconHeight'] ??
                                                                113)
                                                            .toDouble(),
                                                    iconWidth:
                                                        (item['iconWidth'] ??
                                                                119)
                                                            .toDouble(),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                        SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColor.lowlightgreen,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 17,
                                                  ),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    AppImages.buttonArrow,
                                                    color: AppColor.lightgreen,
                                                    height: 20,
                                                  ),
                                                  SizedBox(height: 1),
                                                  Text(
                                                    'Go',
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13,
                                                          color:
                                                              AppColor
                                                                  .lightgreen,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 35),
                                        SizedBox(
                                          height: 70,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        AppColor.white
                                                            .withOpacity(0.3),
                                                        AppColor.lowLightgray,
                                                        AppColor.lowLightgray,
                                                        AppColor.lowLightgray,
                                                        AppColor.lowLightgray,
                                                        AppColor.lowLightgray,
                                                        AppColor.white
                                                            .withOpacity(0.3),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.topRight,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Positioned(
                                                top: -20,
                                                bottom: -20,
                                                left: 0,
                                                right: 0,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: classData.length,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                        vertical: 5,
                                                      ),
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    final item =
                                                        classData[index];
                                                    final grade =
                                                        item['grade']!;
                                                    final section =
                                                        item['section']!;
                                                    final isSelected =
                                                        index == selectedIndex;

                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex = index;
                                                        });
                                                      },
                                                      child: AnimatedContainer(
                                                        duration: Duration(
                                                          milliseconds: 40,
                                                        ),
                                                        curve: Curves.easeInOut,
                                                        width: 75,
                                                        height:
                                                            isSelected
                                                                ? 50
                                                                : 50,
                                                        margin:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              isSelected
                                                                  ? AppColor
                                                                      .white
                                                                  : Colors
                                                                      .transparent,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                16,
                                                              ),
                                                          border:
                                                              isSelected
                                                                  ? Border.all(
                                                                    color:
                                                                        AppColor
                                                                            .black,
                                                                    width: 1.5,
                                                                  )
                                                                  : null,
                                                          boxShadow:
                                                              isSelected
                                                                  ? [
                                                                    BoxShadow(
                                                                      color: AppColor
                                                                          .white
                                                                          .withOpacity(
                                                                            0.5,
                                                                          ),
                                                                      blurRadius:
                                                                          10,
                                                                      offset:
                                                                          Offset(
                                                                            0,
                                                                            4,
                                                                          ),
                                                                    ),
                                                                  ]
                                                                  : [],
                                                        ),
                                                        child:
                                                            isSelected
                                                                ? Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ShaderMask(
                                                                          shaderCallback:
                                                                              (
                                                                                bounds,
                                                                              ) => const LinearGradient(
                                                                                colors: [
                                                                                  AppColor.black,
                                                                                  AppColor.black,
                                                                                ],
                                                                                begin:
                                                                                    Alignment.topLeft,
                                                                                end:
                                                                                    Alignment.bottomRight,
                                                                              ).createShader(
                                                                                Rect.fromLTWH(
                                                                                  0,
                                                                                  0,
                                                                                  bounds.width,
                                                                                  bounds.height,
                                                                                ),
                                                                              ),
                                                                          blendMode:
                                                                              BlendMode.srcIn,
                                                                          child: Text(
                                                                            '${grade}',
                                                                            style: GoogleFont.ibmPlexSans(
                                                                              fontSize:
                                                                                  28,
                                                                              color:
                                                                                  AppColor.black,
                                                                              fontWeight:
                                                                                  FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        // Padding(
                                                                        //   padding:
                                                                        //       const EdgeInsets.only(
                                                                        //         top: 8.0,
                                                                        //       ),
                                                                        //   child: ShaderMask(
                                                                        //     shaderCallback:
                                                                        //         (
                                                                        //           bounds,
                                                                        //         ) => const LinearGradient(
                                                                        //           colors: [
                                                                        //             AppColor
                                                                        //                 .blueG1,
                                                                        //             AppColor
                                                                        //                 .blue,
                                                                        //           ],
                                                                        //           begin:
                                                                        //               Alignment.topLeft,
                                                                        //           end:
                                                                        //               Alignment.bottomRight,
                                                                        //         ).createShader(
                                                                        //           Rect.fromLTWH(
                                                                        //             0,
                                                                        //             0,
                                                                        //             bounds
                                                                        //                 .width,
                                                                        //             bounds
                                                                        //                 .height,
                                                                        //           ),
                                                                        //         ),
                                                                        //     blendMode:
                                                                        //         BlendMode
                                                                        //             .srcIn,
                                                                        //     child: Text(
                                                                        //       'th',
                                                                        //       style: GoogleFont.ibmPlexSans(
                                                                        //         fontSize:
                                                                        //             14,
                                                                        //         color:
                                                                        //             Colors
                                                                        //                 .white,
                                                                        //         fontWeight:
                                                                        //             FontWeight
                                                                        //                 .bold,
                                                                        //       ),
                                                                        //     ),
                                                                        //   ),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                        bottom:
                                                                            0,
                                                                      ),
                                                                      padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            5,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            AppColor.black,
                                                                        borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                            40,
                                                                          ),
                                                                          topRight: Radius.circular(
                                                                            40,
                                                                          ),
                                                                          bottomLeft:
                                                                              Radius.circular(
                                                                                0,
                                                                              ),
                                                                          bottomRight:
                                                                              Radius.circular(
                                                                                0,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      child: Text(
                                                                        section,
                                                                        style: GoogleFont.ibmPlexSans(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              AppColor.white,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                                : Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          12.0,
                                                                    ),
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                25,
                                                                            vertical:
                                                                                3,
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                            color:
                                                                                AppColor.white,
                                                                            borderRadius: BorderRadius.circular(
                                                                              20,
                                                                            ),
                                                                          ),
                                                                          child: Text(
                                                                            grade,
                                                                            style: GoogleFont.ibmPlexSans(
                                                                              fontSize:
                                                                                  14,
                                                                              color:
                                                                                  AppColor.gray,
                                                                              fontWeight:
                                                                                  FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          section,
                                                                          style: GoogleFont.ibmPlexSans(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                AppColor.lightgray,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 50),
                                        Center(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          AttendanceStart(),
                                                ),
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: AppColor.blue,
                                                width: 1.5,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 60,
                                                vertical: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Take Attenedence',
                                                  style: GoogleFont.ibmPlexSans(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.blue,
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Image.asset(
                                                  AppImages.doubleArrow,
                                                  height: 19,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Container(
//   decoration: BoxDecoration(
//     gradient: LinearGradient(
//       colors: [
//         AppColor.greenG1,
//         AppColor.greenG1,
//         AppColor.greenG1.withOpacity(0.9),
//         AppColor.greenG2.withOpacity(0.5),
//         AppColor.greenG3.withOpacity(0.5),
//         AppColor.white.withOpacity(0.5),
//         AppColor.white,
//         AppColor.white,
//       ],
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//     ),
//     borderRadius: BorderRadius.circular(16),
//   ),
//   child: Stack(
//     children: [
//       Image.asset(
//         AppImages.bcImage,
//         height: 249,
//         width: 187,
//       ),
//       Positioned(
//         child: Padding(
//           padding: const EdgeInsets.all(25.0),
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Assign',
//                 style: GoogleFont.ibmPlexSans(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w800,
//                   color: AppColor.white,
//                 ),
//               ),
//               Text(
//                 'Homework',
//                 style: GoogleFont.ibmPlexSans(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w500,
//                   color: AppColor.white,
//                 ),
//               ),
//               SizedBox(height: 10),
//               Image.asset(
//                 AppImages.Homework,
//                 height: 113,
//                 width: 139,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ],
//   ),
// ),
