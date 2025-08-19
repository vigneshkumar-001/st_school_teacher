import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:st_teacher_app/Core/Utility/app_color.dart';
import 'package:st_teacher_app/Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Attendance/attendance_history_student.dart';
import '../Attendance/attendance_start.dart';
import '../Menu/menu_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'dart:ui' show lerpDouble; // so we can call lerpDouble(...)

class Home extends StatefulWidget {
  final String? pages;
  const Home({super.key, this.pages, required String page});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final PageController _pageController;

  int _currentIndex = 0;
  int _current = 1;
  int selectedIndex = 0;
  int subjectIndex = 0;
  bool showThirdContainer = false;

  double currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.70,   // shows side peeks; adjust 0.66–0.75
      initialPage: 1,           // middle card selected on start
    );
    currentPage = 1;
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
          AppColor.orangeG1,
          AppColor.orangeG1.withOpacity(0.80),
          AppColor.orangeG1.withOpacity(0.75),
          AppColor.orangeG1.withOpacity(0.70),
          AppColor.orangeG1.withOpacity(0.65),
          AppColor.orangeG1.withOpacity(0.60),
          AppColor.orangeG1.withOpacity(0.50),
          AppColor.orangeG1.withOpacity(0.45),
          AppColor.orangeG1.withOpacity(0.40),
          AppColor.orangeG1.withOpacity(0.35),
          AppColor.orangeG1.withOpacity(0.25),
          AppColor.orangeG1.withOpacity(0.20),
          AppColor.orangeG1.withOpacity(0.15),
          AppColor.orangeG1.withOpacity(0.10),
          AppColor.orangeG1.withOpacity(0.08),
          AppColor.orangeG1.withOpacity(0.04),
          AppColor.white.withOpacity(0.2),
          AppColor.white.withOpacity(0.10),
          AppColor.white.withOpacity(0.20),
          AppColor.white,
          AppColor.white,
          AppColor.white,
          AppColor.white,
          AppColor.white,
          AppColor.white,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      'mainText1': 'Schedule',
      'mainText2': 'Exam',
      'iconImage': AppImages.scheduleExam,
      'bcImage': AppImages.bcImage,
    },

    {
      'gradient': LinearGradient(
        colors: [
          AppColor.greenG1,
          AppColor.greenG1,
          AppColor.greenG1,
          AppColor.greenG1,
          AppColor.greenG1.withOpacity(0.95),
          AppColor.greenG1.withOpacity(0.90),
          AppColor.greenG1.withOpacity(0.85),
          AppColor.greenG1.withOpacity(0.80),
          AppColor.greenG1.withOpacity(0.75),
          AppColor.greenG1.withOpacity(0.70),
          AppColor.greenG1.withOpacity(0.65),
          AppColor.greenG1.withOpacity(0.60),
          AppColor.greenG1.withOpacity(0.55),
          AppColor.greenG1.withOpacity(0.50),
          AppColor.greenG1.withOpacity(0.45),
          AppColor.greenG1.withOpacity(0.40),
          AppColor.greenG1.withOpacity(0.35),
          AppColor.greenG1.withOpacity(0.30),
          AppColor.greenG2.withOpacity(0.25),
          AppColor.greenG2.withOpacity(0.20),
          AppColor.greenG2.withOpacity(0.15),
          AppColor.greenG2.withOpacity(0.10),
          AppColor.greenG2.withOpacity(0.06),
          AppColor.white.withOpacity(0.15),
          AppColor.white.withOpacity(0.20),
          AppColor.white.withOpacity(0.30),
          AppColor.white,
          AppColor.white,
          AppColor.white,
          AppColor.white,
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
    },

    {
      'gradient': LinearGradient(
        colors: [
          AppColor.bluehG1,
          AppColor.bluehG1,
          AppColor.bluehG1,
          AppColor.bluehG1,
          AppColor.bluehG1.withOpacity(0.95),
          AppColor.bluehG1.withOpacity(0.90),
          AppColor.bluehG1.withOpacity(0.85),
          AppColor.bluehG1.withOpacity(0.80),
          AppColor.bluehG1.withOpacity(0.75),
          AppColor.bluehG1.withOpacity(0.70),
          AppColor.bluehG1.withOpacity(0.65),
          AppColor.bluehG1.withOpacity(0.60),
          AppColor.bluehG1.withOpacity(0.55),
          AppColor.bluehG1.withOpacity(0.50),
          AppColor.bluehG1.withOpacity(0.45),
          AppColor.bluehG1.withOpacity(0.40),
          AppColor.bluehG1.withOpacity(0.35),
          AppColor.bluehG1.withOpacity(0.30),
          AppColor.bluehG1.withOpacity(0.25),
          AppColor.bluehG1.withOpacity(0.20),
          AppColor.bluehG1.withOpacity(0.15),
          AppColor.bluehG1.withOpacity(0.10),
          AppColor.bluehG1.withOpacity(0.06),
          AppColor.white.withOpacity(0.06),
          AppColor.white.withOpacity(0.10),
          AppColor.white.withOpacity(0.20),
          AppColor.white,
          AppColor.white,
          AppColor.white,
          AppColor.white,
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
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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

                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MenuScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Menu',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 14,
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(width: 7),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(11.0),
                                          child: Image.asset(
                                            AppImages.menuImage,
                                            height: 23.2,
                                          ),
                                        ),
                                      ),
                                    ],
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Actions',
                                      style: GoogleFont.ibmPlexSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: LayoutBuilder(
                                        builder: (context, c) {
                                          final panelW = c.maxWidth;
                                          final cardW = panelW * 0.58;
                                          final insetX = cardW * 0.42;
                                          const dropSide = 40.0;

                                          const cardIconSizes = [
                                            {
                                              "selectedH": 200,
                                              "selectedW": 220,
                                              "sideH": 160,
                                              "sideW": 170,
                                            }, // card 0
                                            {
                                              "selectedH": 450,
                                              "selectedW": 400,
                                              "sideH": 150,
                                              "sideW": 156,
                                            }, // card 1 (bigger)
                                            {
                                              "selectedH": 410,
                                              "selectedW": 450,
                                              "sideH": 190,
                                              "sideW": 200,
                                            }, // card 2
                                          ];

                                          return Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              // gestures
                                              PageView.builder(
                                                controller: _pageController,
                                                itemCount: sliderItems.length,
                                                reverse: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics: const PageScrollPhysics(),
                                                onPageChanged: (i) {
                                                  final mapped = (sliderItems.length - 1) - i; // keep index growing to the right
                                                  setState(() => currentPage = mapped.toDouble());
                                                },

                                                itemBuilder:
                                                    (_, __) =>
                                                        const SizedBox.shrink(),
                                              ),

                                              Positioned.fill(
                                                child: IgnorePointer(
                                                  ignoring: true,
                                                  child: AnimatedBuilder(

                                                    animation: _pageController,
                                                    builder: (context, _) {
                                                      final page =
                                                          _pageController
                                                                  .hasClients
                                                              ? (_pageController
                                                                      .page ??
                                                                  _pageController
                                                                      .initialPage
                                                                      .toDouble())
                                                              : currentPage;
                                                      final order =
                                                          List<int>.generate(
                                                            sliderItems.length,
                                                            (i) => i,
                                                          )..sort((a, b) {
                                                            final fa =
                                                                1 -
                                                                (page - a)
                                                                    .abs()
                                                                    .clamp(
                                                                      0.0,
                                                                      1.0,
                                                                    );
                                                            final fb =
                                                                1 -
                                                                (page - b)
                                                                    .abs()
                                                                    .clamp(
                                                                      0.0,
                                                                      1.0,
                                                                    );
                                                            return fa.compareTo(
                                                              fb,
                                                            );
                                                          });

                                                      double lerp(
                                                        double a,
                                                        double b,
                                                        double t,
                                                      ) => a + (b - a) * t;

                                                      return Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          for (final i in order)
                                                            Builder(
                                                              builder: (
                                                                context,
                                                              ) {
                                                                final delta =
                                                                    page - i;
                                                                final dist =
                                                                    delta
                                                                        .abs()
                                                                        .clamp(
                                                                          0.0,
                                                                          1.0,
                                                                        );
                                                                final focus =
                                                                    1.0 - dist;
                                                                final isCenter =
                                                                    dist <
                                                                    0.001;

                                                                // zoom/position
                                                                final scale =
                                                                    lerp(
                                                                      0.75,
                                                                      0.80,
                                                                      focus,
                                                                    );
                                                                final dx = lerp(
                                                                  (page > i)
                                                                      ? insetX
                                                                      : -insetX,
                                                                  0,
                                                                  focus,
                                                                );
                                                                final dy = lerp(
                                                                  dropSide,
                                                                  0,
                                                                  focus,
                                                                );

                                                                final m =
                                                                    Matrix4.identity()
                                                                      ..setEntry(
                                                                        3,
                                                                        2,
                                                                        0.001,
                                                                      )
                                                                      ..translate(
                                                                        dx,
                                                                        dy,
                                                                      )
                                                                      ..scale(
                                                                        scale,
                                                                      );

                                                                Alignment
                                                                iconAlign;
                                                                TextAlign
                                                                textAlign;
                                                                if (i == 0) {
                                                                  iconAlign =
                                                                      Alignment
                                                                          .centerRight;
                                                                  textAlign =
                                                                      TextAlign
                                                                          .end;
                                                                } else if (i ==
                                                                    sliderItems
                                                                            .length -
                                                                        1) {
                                                                  iconAlign =
                                                                      Alignment
                                                                          .centerLeft;
                                                                  textAlign =
                                                                      TextAlign
                                                                          .start;
                                                                } else {
                                                                  iconAlign =
                                                                      Alignment
                                                                          .center;
                                                                  textAlign =
                                                                      TextAlign
                                                                          .left;
                                                                }

                                                                final sizes =
                                                                    cardIconSizes[i];

                                                                final double
                                                                iconY =
                                                                    isCenter
                                                                        ? 40.0
                                                                        : -2.0;

                                                                final int
                                                                iconH =
                                                                    isCenter
                                                                        ? (sizes["selectedH"]! *
                                                                                scale)
                                                                            .toInt()
                                                                        : (sizes["sideH"]! *
                                                                                scale)
                                                                            .toInt();

                                                                final int
                                                                iconW =
                                                                    isCenter
                                                                        ? (sizes["selectedW"]! *
                                                                                scale)
                                                                            .toInt()
                                                                        : (sizes["sideW"]! *
                                                                                scale)
                                                                            .toInt();

                                                                return Positioned.fill(
                                                                  child: Center(
                                                                    child: SizedBox(
                                                                      width:
                                                                          cardW,
                                                                      child: Transform(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        transform:
                                                                            m,
                                                                        child: Material(
                                                                          // borderRadius: BorderRadius.circular(
                                                                          //   22,
                                                                          // ),
                                                                          child: Opacity(
                                                                            opacity:
                                                                                1.0, // always visible
                                                                            child: CommonContainer.carouselSlider(
                                                                              isSelect:
                                                                                  isCenter,
                                                                              mainText1:
                                                                                  sliderItems[i]['mainText1'],
                                                                              mainText2:
                                                                                  sliderItems[i]['mainText2'],
                                                                              iconImage:
                                                                                  sliderItems[i]['iconImage'],
                                                                              bcImage:
                                                                                  sliderItems[i]['bcImage'],
                                                                              gradient:
                                                                                  sliderItems[i]['gradient'],
                                                                              iconHeight:
                                                                                  iconH,
                                                                              iconWidth:
                                                                                  iconW,
                                                                              iconAlignment:
                                                                                  iconAlign,
                                                                              iconYOffset:
                                                                                  iconY,
                                                                              textAlign:
                                                                                  textAlign,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(height: 12),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.lowlightgreen,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
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
                                                style: GoogleFont.ibmPlexSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                  color: AppColor.lightgreen,
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
                                                    AppColor.white.withOpacity(
                                                      0.3,
                                                    ),
                                                    AppColor.lowLightgray,
                                                    AppColor.lowLightgray,
                                                    AppColor.lowLightgray,
                                                    AppColor.lowLightgray,
                                                    AppColor.lowLightgray,
                                                    AppColor.white.withOpacity(
                                                      0.3,
                                                    ),
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
                                              scrollDirection: Axis.horizontal,
                                              itemCount: classData.length,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 2,
                                                    vertical: 5,
                                                  ),
                                              itemBuilder: (context, index) {
                                                final item = classData[index];
                                                final grade = item['grade']!;
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
                                                        isSelected ? 50 : 50,
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 0,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isSelected
                                                              ? AppColor.white
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
                                                                          BlendMode
                                                                              .srcIn,
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
                                                                  ],
                                                                ),
                                                                Container(
                                                                  margin:
                                                                      EdgeInsets.only(
                                                                        bottom:
                                                                            0,
                                                                      ),
                                                                  padding:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            5,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        AppColor
                                                                            .black,
                                                                    borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                            40,
                                                                          ),
                                                                      topRight:
                                                                          Radius.circular(
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
                                                                          AppColor
                                                                              .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                            : Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
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
                                                                        borderRadius:
                                                                            BorderRadius.circular(
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
                                                                      height: 5,
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
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
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
