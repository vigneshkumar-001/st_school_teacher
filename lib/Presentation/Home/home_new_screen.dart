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
import 'controller/message_controller.dart';
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
  final MessageController msgController = Get.put(MessageController());
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

  double getCenteredPadding(BuildContext context, int itemCount) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = 75.0; // Width of each class card
    final spacing = 0.0; // You can add spacing if your cards have margin

    final totalWidth = itemCount * itemWidth + (itemCount - 1) * spacing;
    final remainingSpace = screenWidth - totalWidth;

    return remainingSpace > 0 ? remainingSpace / 2 : 15.0;
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
                                Obx(
                                  () => Text(
                                    controller
                                            .teacherDataResponse
                                            .value
                                            ?.data
                                            .greetingText
                                            .toString() ??
                                        '',
                                    style: GoogleFont.ibmPlexSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                      color: AppColor.white,
                                    ),
                                  ),
                                ),

                                // Text(
                                //   'Good Morning',
                                //   style: GoogleFont.ibmPlexSans(
                                //     fontWeight: FontWeight.w600,
                                //     fontSize: 25,
                                //     color: AppColor.white,
                                //   ),
                                // ),

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
                                  final msgCount = msgController.count.value;

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
                                        horizontal: 27,
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
                                              child: LayoutBuilder(
                                                builder: (
                                                  context,
                                                  constraints,
                                                ) {
                                                  final screenWidth =
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width;
                                                  final screenHeight =
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height;

                                                  // Responsive sizing
                                                  final containerWidth =
                                                      screenWidth *
                                                      0.85; // 85% of screen width
                                                  final containerHeight =
                                                      screenHeight *
                                                      0.22; // 22% of screen height

                                                  return Container(
                                                    width: containerWidth,
                                                    height: containerHeight,
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
                                                        begin:
                                                            Alignment.topRight,
                                                        end: Alignment.topLeft,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        // ✅ Background image (non-interactive)
                                                        Positioned.fill(
                                                          child: IgnorePointer(
                                                            child: Image.asset(
                                                              AppImages.bcImage,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),

                                                        // ✅ Foreground content
                                                        Positioned(
                                                          top:
                                                              containerHeight *
                                                              0.1,
                                                          left:
                                                              containerWidth *
                                                              0.05,
                                                          right:
                                                              containerWidth *
                                                              0.05,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              // Texts (Assign Homework)
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
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
                                                                      fontSize:
                                                                          containerWidth *
                                                                          0.08,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          AppColor
                                                                              .white,
                                                                    ).copyWith(
                                                                      shadows: const [
                                                                        Shadow(
                                                                          offset: Offset(
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
                                                                      fontSize:
                                                                          containerWidth *
                                                                          0.05,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          AppColor
                                                                              .white,
                                                                    ).copyWith(
                                                                      shadows: const [
                                                                        Shadow(
                                                                          offset: Offset(
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

                                                              // Image
                                                              Image.asset(
                                                                AppImages
                                                                    .Homework,
                                                                height:
                                                                    containerHeight *
                                                                    0.75,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 14),
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
                                                child: LayoutBuilder(
                                                  builder: (
                                                    context,
                                                    constraints,
                                                  ) {
                                                    final screenWidth =
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width;
                                                    final screenHeight =
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.height;

                                                    // ✅ Responsive scaling
                                                    final containerWidth =
                                                        screenWidth *
                                                        0.40; // ~40% of screen width
                                                    final containerHeight =
                                                        screenHeight *
                                                        0.25; // ~25% of screen height

                                                    return Container(
                                                      width: containerWidth,
                                                      height: containerHeight,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            AppColor.bluehG1,
                                                            AppColor.bluehG1,
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.95,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.9,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.85,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.8,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.75,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.7,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.65,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.6,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.55,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.5,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.45,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.4,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.35,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.25,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.15,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.1,
                                                                ),
                                                            AppColor.bluehG1
                                                                .withOpacity(
                                                                  0.06,
                                                                ),
                                                            AppColor.white
                                                                .withOpacity(
                                                                  0.06,
                                                                ),
                                                            AppColor.white
                                                                .withOpacity(
                                                                  0.1,
                                                                ),
                                                            AppColor.white
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                            AppColor.white,
                                                            AppColor.white,
                                                          ],
                                                          begin:
                                                              Alignment
                                                                  .topCenter,
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
                                                          // ✅ Background image
                                                          Positioned.fill(
                                                            child: IgnorePointer(
                                                              child: Image.asset(
                                                                AppImages
                                                                    .bcImage,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                              ),
                                                            ),
                                                          ),

                                                          // ✅ Foreground content
                                                          Positioned(
                                                            top:
                                                                containerHeight *
                                                                0.08,
                                                            left: 0,
                                                            right: 0,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Conduct',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: GoogleFont.ibmPlexSans(
                                                                    fontSize:
                                                                        containerWidth *
                                                                        0.1, // responsive
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
                                                                    fontSize:
                                                                        containerWidth *
                                                                        0.16,
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
                                                                SizedBox(
                                                                  height:
                                                                      containerHeight *
                                                                      0.05,
                                                                ),
                                                                Image.asset(
                                                                  AppImages
                                                                      .Quiz,
                                                                  height:
                                                                      containerHeight *
                                                                      0.45,
                                                                  width:
                                                                      containerWidth *
                                                                      0.6,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
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
                                                    child: LayoutBuilder(
                                                      builder: (
                                                        context,
                                                        constraints,
                                                      ) {
                                                        final screenWidth =
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.width;
                                                        final screenHeight =
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.height;

                                                        // ✅ Responsive sizing
                                                        final containerWidth =
                                                            screenWidth *
                                                            0.40; // 40% of screen width
                                                        final containerHeight =
                                                            screenHeight *
                                                            0.25; // 25% of screen height

                                                        return Container(
                                                          width: containerWidth,
                                                          height:
                                                              containerHeight,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20,
                                                                ),
                                                            gradient: const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0xFFFBBF30,
                                                                ),
                                                                Color(
                                                                  0xFFDD751E,
                                                                ),
                                                                Color(
                                                                  0xFFD96A1B,
                                                                ),
                                                              ],
                                                              begin:
                                                                  Alignment
                                                                      .topLeft,
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
                                                              // ✅ background pattern image
                                                              Positioned.fill(
                                                                child: IgnorePointer(
                                                                  child: Opacity(
                                                                    opacity:
                                                                        0.08,
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

                                                              // ✅ bottom white fade overlay
                                                              Positioned(
                                                                left: 0,
                                                                right: 0,
                                                                bottom: 0,
                                                                height:
                                                                    containerHeight *
                                                                    0.55,
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius.only(
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
                                                                            Alignment.topCenter,
                                                                        end:
                                                                            Alignment.bottomCenter,
                                                                        colors: [
                                                                          AppColor.white.withOpacity(
                                                                            0.099,
                                                                          ),
                                                                          AppColor.white.withOpacity(
                                                                            0.099,
                                                                          ),
                                                                          AppColor.white.withOpacity(
                                                                            0.099,
                                                                          ),
                                                                          Colors
                                                                              .white,
                                                                        ],
                                                                        stops: const [
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

                                                              // ✅ top text ("Schedule" / "Exam")
                                                              Positioned(
                                                                top:
                                                                    containerHeight *
                                                                    0.09,
                                                                left: 0,
                                                                right: 0,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Schedule',
                                                                      style: GoogleFont.ibmPlexSans(
                                                                        fontSize:
                                                                            containerWidth *
                                                                            0.1, // dynamic
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color:
                                                                            Colors.white,
                                                                      ).copyWith(
                                                                        shadows: const [
                                                                          Shadow(
                                                                            offset: Offset(
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
                                                                    SizedBox(
                                                                      height:
                                                                          containerHeight *
                                                                          0.01,
                                                                    ),
                                                                    Text(
                                                                      'Exam',
                                                                      style: GoogleFont.ibmPlexSans(
                                                                        fontSize:
                                                                            containerWidth *
                                                                            0.18, // dynamic
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        color:
                                                                            Colors.white,
                                                                      ).copyWith(
                                                                        shadows: const [
                                                                          Shadow(
                                                                            offset: Offset(
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

                                                              // ✅ bottom image icon
                                                              Positioned(
                                                                bottom:
                                                                    containerHeight *
                                                                    0.07,
                                                                left: 0,
                                                                right: 0,
                                                                child: Center(
                                                                  child: Image.asset(
                                                                    AppImages
                                                                        .scheduleExam,
                                                                    height:
                                                                        containerHeight *
                                                                        0.45,
                                                                    width:
                                                                        containerWidth *
                                                                        0.55,
                                                                    fit:
                                                                        BoxFit
                                                                            .contain,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 30),

                                    // Class chips scroller
                                    SizedBox(
                                      height: 70,
                                      child: Obx(() {
                                        final classList =
                                            teacherClassController.classList;
                                        final selectedIndex =
                                            teacherClassController
                                                .selectedClassIndex
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
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  height: 110,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        classList.length <= 4
                                                            ? const NeverScrollableScrollPhysics()
                                                            : const BouncingScrollPhysics(),
                                                    itemCount: classList.length,
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          classList.length <= 4
                                                              ? getCenteredPadding(
                                                                context,
                                                                classList
                                                                    .length,
                                                              )
                                                              : 15,
                                                    ),
                                                    itemBuilder: (
                                                      context,
                                                      index,
                                                    ) {
                                                      final item =
                                                          classList[index];
                                                      final isSelected =
                                                          index ==
                                                          selectedIndex;

                                                      return GestureDetector(
                                                        onTap: () {
                                                          teacherClassController
                                                              .selectedClass
                                                              .value = item;
                                                          teacherClassController
                                                              .selectedClassIndex
                                                              .value = index;

                                                          AppLogger.log.i(
                                                            "Selected class: ${item.name} - ${item.section}",
                                                          );

                                                          // ✅ auto-filter subjects by this class
                                                          teacherClassController
                                                              .filterSubjectsByClass(
                                                                item.id,
                                                              );
                                                        },
                                                        child: AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                milliseconds:
                                                                    200,
                                                              ),
                                                          curve:
                                                              Curves.easeInOut,
                                                          width: 85,
                                                          height: 50,
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
                                                                      width:
                                                                          1.5,
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
                                                                            const Offset(
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
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Center(
                                                                        child: Text(
                                                                          item.name,
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
                                                                        margin: const EdgeInsets.only(
                                                                          bottom:
                                                                              0,
                                                                        ),
                                                                        padding: const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              12,
                                                                          vertical:
                                                                              5,
                                                                        ),
                                                                        decoration: const BoxDecoration(
                                                                          color:
                                                                              AppColor.black,
                                                                          borderRadius: BorderRadius.only(
                                                                            topLeft: Radius.circular(
                                                                              40,
                                                                            ),
                                                                            topRight: Radius.circular(
                                                                              40,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child: Text(
                                                                          item.section,
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
                                                                            20.0,
                                                                      ),
                                                                      child: Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
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
                                                                              item.name,
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
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            item.section,
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
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),

                                    const SizedBox(height: 40),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
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
                                                  Obx(
                                                    () => Text(
                                                      msgController
                                                                  .count
                                                                  .value !=
                                                              0
                                                          ? msgController
                                                              .count
                                                              .value
                                                              .toString()
                                                          : '',
                                                      style:
                                                          GoogleFont.ibmPlexSans(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                AppColor.white,
                                                          ),
                                                    ),
                                                  ),

                                                  SizedBox(width: 4),
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
