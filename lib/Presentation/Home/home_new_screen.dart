import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:st_teacher_app/Core/Utility/custom_navigation.dart';
import 'package:st_teacher_app/Core/consents.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/drop_in_touch_animation.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../dummy_screen.dart';
import '../Attendance/attendance_new_screen.dart';
import '../Exam Screen/screens/exam_create.dart';
import '../Homework/controller/teacher_class_controller.dart';
import '../Homework/homework_create.dart';
import '../Menu/menu_screen.dart';
import '../Profile/controller/teacher_data_controller.dart';
import '../Quiz Screen/quiz_screen_create.dart';
import 'message_screen.dart';

class HomeNewScreen extends StatefulWidget {
  final String? pages;
  const HomeNewScreen({super.key, this.pages, required String page});

  @override
  State<HomeNewScreen> createState() => _HomeNewScreenState();
}

class _HomeNewScreenState extends State<HomeNewScreen> {
  late final PageController _pageController;
  final TeacherClassController teacherClassController = Get.put(
    TeacherClassController(),
  );
  final TeacherDataController controller = Get.put(TeacherDataController());
  int _currentIndex = 0;
  int _current = 1;
  int selectedIndex = 0;
  int subjectIndex = 0;
  bool showThirdContainer = false;
  double currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await teacherClassController.getTeacherClass();
    });

    _pageController = PageController(
      viewportFraction: 0.70, // shows side peeks; adjust 0.66–0.75
      initialPage: 1, // middle card selected on start
    );

    currentPage = 1;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

                          SizedBox(height: 15),
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

                                /* Text(
                                  'Megha!',
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 33,
                                    color: AppColor.white,
                                  ),
                                ),*/
                                Obx(() {
                                  final staffName =
                                      controller
                                          .teacherDataResponse
                                          .value
                                          ?.data
                                          .profile
                                          .staffName;

                                  if (staffName == null || staffName.isEmpty) {
                                    return Text(
                                      '',
                                      style: GoogleFont.ibmPlexSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: AppColor.white,
                                      ),
                                    );
                                  }

                                  return Text(
                                    '$staffName!',
                                    style: GoogleFont.ibmPlexSans(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25,
                                      color: AppColor.white,
                                    ),
                                  );
                                }),
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
                        top: 95,
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
                                child: Column(
                                  children: [
                                    Text(
                                      'Actions',
                                      style: GoogleFont.ibmPlexSans(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Assign Homework card
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 31,
                                      ),
                                      child: Column(
                                        children: [
                                          BouncyTap(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            onTap: () {
                                              final selected =
                                                  teacherClassController
                                                      .selectedClass
                                                      .value;
                                              AppLogger.log.i(selected?.name);
                                              AppLogger.log.i(
                                                selected?.section,
                                              );

                                              if (selected == null) {
                                                Get.snackbar(
                                                  "Error",
                                                  "Please select a class",
                                                );
                                                return;
                                              }
                                              CustomNavigation.pushFadeScale(
                                                context,

                                                HomeworkCreate(
                                                  className:
                                                      selected
                                                          .name, // ✅ selected is non-null here
                                                  section: selected.section,
                                                ),
                                              );
                                            },
                                            child: Ink(
                                              // ✅ lets ripple + clipping render over your gradient
                                              height: 180,
                                              width: 325,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColor.greenG4
                                                        .withOpacity(0.9),
                                                    AppColor.greenG4
                                                        .withOpacity(0.8),
                                                    AppColor.greenG4
                                                        .withOpacity(0.8),
                                                    AppColor.greenG4
                                                        .withOpacity(0.7),
                                                    AppColor.greenG1
                                                        .withOpacity(0.8),
                                                    AppColor.greenG1
                                                        .withOpacity(0.8),
                                                    AppColor.greenG1
                                                        .withOpacity(0.8),
                                                    AppColor.greenG1
                                                        .withOpacity(0.8),
                                                    AppColor.greenG1
                                                        .withOpacity(0.8),
                                                  ],
                                                  begin: Alignment.topRight,
                                                  end: Alignment.topLeft,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned.fill(
                                                    child: IgnorePointer(
                                                      child: Image.asset(
                                                        AppImages.bcImage,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 20,
                                                    left: 5,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 25,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                'Assign ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: GoogleFont.ibmPlexSans(
                                                                  fontSize: 26,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      AppColor
                                                                          .white,
                                                                ).copyWith(
                                                                  shadows: const [
                                                                    Shadow(
                                                                      offset:
                                                                          Offset(
                                                                            0,
                                                                            5,
                                                                          ),
                                                                      blurRadius:
                                                                          12,
                                                                      color: Color(
                                                                        0x40000000,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Text(
                                                                'Homework',
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: GoogleFont.ibmPlexSans(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      AppColor
                                                                          .white,
                                                                ).copyWith(
                                                                  shadows: const [
                                                                    Shadow(
                                                                      offset:
                                                                          Offset(
                                                                            0,
                                                                            5,
                                                                          ),
                                                                      blurRadius:
                                                                          12,
                                                                      color: Color(
                                                                        0x40000000,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 30,
                                                          ),
                                                          Image.asset(
                                                            AppImages.Homework,
                                                            height: 130,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              BouncyTap(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onTap: () {
                                                  final selected =
                                                      teacherClassController
                                                          .selectedClass
                                                          .value;
                                                  AppLogger.log.i(
                                                    selected?.name,
                                                  );
                                                  AppLogger.log.i(
                                                    selected?.section,
                                                  );
                                                  if (selected == null) {
                                                    Get.snackbar(
                                                      "Error",
                                                      "Please select a class",
                                                    );
                                                    return;
                                                  }
                                                  CustomNavigation.pushFadeScale(
                                                    context,

                                                    QuizScreenCreate(
                                                      className: selected.name,
                                                      section: selected.section,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: 190,
                                                  width: 155.5,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        AppColor.bluehG1,
                                                        AppColor.bluehG1,
                                                        AppColor.bluehG1,
                                                        AppColor.bluehG1,
                                                        AppColor.bluehG1
                                                            .withOpacity(0.95),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.90),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.85),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.80),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.75),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.70),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.65),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.60),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.55),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.50),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.45),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.40),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.35),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.30),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.25),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.20),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.15),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.10),
                                                        AppColor.bluehG1
                                                            .withOpacity(0.06),
                                                        AppColor.white
                                                            .withOpacity(0.06),
                                                        AppColor.white
                                                            .withOpacity(0.10),
                                                        AppColor.white
                                                            .withOpacity(0.20),
                                                        AppColor.white,
                                                        AppColor.white,
                                                        AppColor.white,
                                                        AppColor.white,
                                                        AppColor.white,
                                                        AppColor.white,
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end:
                                                          Alignment
                                                              .bottomCenter,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Positioned.fill(
                                                        child: IgnorePointer(
                                                          child: Image.asset(
                                                            AppImages.bcImage,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 15,
                                                        left: 0,
                                                        right: 5,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              'Conduct ',

                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFont.ibmPlexSans(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    AppColor
                                                                        .white,
                                                              ).copyWith(
                                                                shadows: const [
                                                                  Shadow(
                                                                    offset:
                                                                        Offset(
                                                                          0,
                                                                          4,
                                                                        ),
                                                                    blurRadius:
                                                                        12,
                                                                    color: Color(
                                                                      0x40000000,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              'Quiz',

                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFont.ibmPlexSans(
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    AppColor
                                                                        .white,
                                                              ).copyWith(
                                                                shadows: const [
                                                                  Shadow(
                                                                    offset:
                                                                        Offset(
                                                                          0,
                                                                          4,
                                                                        ),
                                                                    blurRadius:
                                                                        12,
                                                                    color: Color(
                                                                      0x40000000,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            Image.asset(
                                                              AppImages.Quiz,
                                                              height: 95,
                                                              width: 90,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      /*   Positioned.fill(
                                                    child: IgnorePointer(
                                                      child: Image.asset(
                                                        AppImages.Homework,
                                                     height: 130,
                                                      ),
                                                    ),
                                                  ),*/
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 14),

                                              BouncyTap(
                                                onTap: () {
                                                  final selected =
                                                      teacherClassController
                                                          .selectedClass
                                                          .value;
                                                  AppLogger.log.i(
                                                    selected?.name,
                                                  );
                                                  AppLogger.log.i(
                                                    selected?.section,
                                                  );
                                                  if (selected == null) {
                                                    Get.snackbar(
                                                      "Error",
                                                      "Please select a class",
                                                    );
                                                    return;
                                                  }
                                                  CustomNavigation.pushFadeScale(
                                                    context,

                                                    ExamCreate(
                                                      className: selected.name,
                                                      section: selected.section,
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        22,
                                                      ), // outer rim radius
                                                  child: Container(
                                                    // crisp white rim around the card
                                                    color: Colors.white,
                                                    padding:
                                                        const EdgeInsets.all(
                                                          2,
                                                        ), // rim thickness
                                                    child: Container(
                                                      height: 190,
                                                      width: 155.5,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                        // FBBF30 → DD751E → D96A1B (top-left → bottom-right)
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(0xFFFBBF30),
                                                            Color(0xFFDD751E),
                                                            Color(0xFFD96A1B),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
                                                          stops: [
                                                            0.0,
                                                            0.55,
                                                            1.0,
                                                          ],
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          // doodle background (very light)
                                                          Positioned.fill(
                                                            child: IgnorePointer(
                                                              child: Opacity(
                                                                opacity: 0.08,
                                                                child: Image.asset(
                                                                  AppImages
                                                                      .bcImage,
                                                                  fit:
                                                                      BoxFit
                                                                          .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          // bottom-only white fade with rounded top edge
                                                          Positioned(
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0,
                                                            height:
                                                                110, // raise/lower white area
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  const BorderRadius.only(
                                                                    topLeft:
                                                                        Radius.elliptical(
                                                                          10,
                                                                          10,
                                                                        ),
                                                                    topRight:
                                                                        Radius.elliptical(
                                                                          10,
                                                                          10,
                                                                        ),
                                                                  ),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                    begin:
                                                                        Alignment
                                                                            .topCenter,
                                                                    end:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    colors: [
                                                                      AppColor
                                                                          .white
                                                                          .withOpacity(
                                                                            0.0999,
                                                                          ),
                                                                      AppColor
                                                                          .white
                                                                          .withOpacity(
                                                                            0.099,
                                                                          ),
                                                                      AppColor
                                                                          .white
                                                                          .withOpacity(
                                                                            0.099,
                                                                          ),
                                                                      Colors
                                                                          .white, // solid at bottom
                                                                    ],
                                                                    stops: [
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.65,
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          // subtle flat white spotlight behind the icon
                                                          /*  Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            top: 20,
                                            child: Center(
                                              child: Transform.scale(
                                                scaleY: 0.20, // flatten circle → oval
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.elliptical(10, 10),
                                                    topRight: Radius.elliptical(10, 10),
                                                  ),
                                                  child: Container(

                                                    decoration:  BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: RadialGradient(
                                                        center: Alignment(0, 0.60),
                                                        radius: 0.90,
                                                        colors: [
                                                          Colors.white.withOpacity(0.5),
                                                          Color(0x66FFFFFF),
                                                          Color(0x00FFFFFF),
                                                        ],
                                                        stops: [0.10, 0.0, 1.0],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),*/

                                                          // texts
                                                          Positioned(
                                                            top: 18,
                                                            left: 0,
                                                            right: 0,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Schedule',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFont.ibmPlexSans(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ).copyWith(
                                                                    shadows: const [
                                                                      Shadow(
                                                                        offset:
                                                                            Offset(
                                                                              0,
                                                                              2,
                                                                            ),
                                                                        blurRadius:
                                                                            6,
                                                                        color: Color(
                                                                          0x55000000,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  'Exam',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFont.ibmPlexSans(
                                                                    fontSize:
                                                                        28, // a touch larger like Figma
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ).copyWith(
                                                                    shadows: const [
                                                                      Shadow(
                                                                        offset:
                                                                            Offset(
                                                                              0,
                                                                              3,
                                                                            ),
                                                                        blurRadius:
                                                                            10,
                                                                        color: Color(
                                                                          0x55000000,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          // icon
                                                          Positioned(
                                                            bottom: 14,
                                                            left: 0,
                                                            right: 0,
                                                            child: Center(
                                                              child: Image.asset(
                                                                AppImages
                                                                    .scheduleExam,
                                                                height: 92,
                                                                width: 84,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 15),

                                    // Class chips scroller
                                    SizedBox(
                                      height: 70,
                                      child: Obx(() {
                                        final classList =
                                            teacherClassController.classList;
                                        final selectedClass =
                                            teacherClassController
                                                .selectedClass
                                                .value;

                                        if (teacherClassController
                                            .isLoading
                                            .value) {
                                          return Center(
                                            child: AppLoader.circularLoader(),
                                          );
                                        }

                                        if (classList.isEmpty) {
                                          return Center(
                                            child: Text("No classes available"),
                                          );
                                        }

                                        return Stack(
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
                                                itemCount: classList.length,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 5,
                                                    ),
                                                itemBuilder: (context, index) {
                                                  final item = classList[index];
                                                  final grade = item.name;
                                                  final section = item.section;
                                                  final isSelected =
                                                      item == selectedClass;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      teacherClassController
                                                          .selectedClass
                                                          .value = item;
                                                      AppLogger.log.i(
                                                        "Selected class: ${item.name} - ${item.section}",
                                                      );
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: Duration(
                                                        milliseconds: 200,
                                                      ),
                                                      curve: Curves.easeInOut,
                                                      width: 75,
                                                      height: 50,
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
                                                                  Center(
                                                                    child: Text(
                                                                      grade,
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
                                                                  Container(
                                                                    margin:
                                                                        EdgeInsets.only(
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
                                        );
                                      }),
                                    ),

                                    const SizedBox(height: 25),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                      ),
                                      child: Row(
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) =>
                                                          AttendanceNewScreen(),
                                                ),
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: AppColor.blue,
                                                width: 1.5,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 14,
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
                                                  'Take Attendance',
                                                  style: GoogleFont.ibmPlexSans(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColor.blue,
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                                Image.asset(
                                                  AppImages.doubleArrow,
                                                  height: 19,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColor.blueG1,
                                                  AppColor.blue.withOpacity(
                                                    0.9,
                                                  ),
                                                ],
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomRight,
                                              ),

                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                      EdgeInsets.symmetric(
                                                        horizontal: 25,
                                                      ),
                                                    ),
                                                shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                elevation:
                                                    MaterialStateProperty.all(
                                                      0,
                                                    ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                      Colors.transparent,
                                                    ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            MessageScreen(),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Text(
                                                  //   '3',
                                                  //   style:
                                                  //       GoogleFont.ibmPlexSans(
                                                  //         fontSize: 15,
                                                  //         fontWeight:
                                                  //             FontWeight.bold,
                                                  //         color:
                                                  //             AppColor.white,
                                                  //       ),
                                                  // ),
                                                  // SizedBox(width: 4),
                                                  Text(
                                                    'Messages',
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColor.white,
                                                        ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Image.asset(
                                                    AppImages.rightSideArrow,
                                                    color: AppColor.white,
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
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
