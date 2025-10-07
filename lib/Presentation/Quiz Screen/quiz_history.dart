import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_teacher_app/Core/Utility/date_and_time_convert.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/Model/quizlist_response.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/quiz_details.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/quiz_screen_create.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'controller/quiz_controller.dart';
import 'details_attend_history.dart';

class QuizHistory extends StatefulWidget {
  const QuizHistory({super.key});

  @override
  State<QuizHistory> createState() => _QuizHistoryState();
}

class _QuizHistoryState extends State<QuizHistory> {
  final QuizController quizController = Get.put(QuizController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await quizController.quizList();
      if (!quizController.classNames.contains(quizController.selectedClassName.value)) {
        quizController.selectClass('All');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          if (quizController.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }

          final groups = quizController.groupedQuizzes;
          final hasData = groups.isNotEmpty;

          if (!hasData) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 80),
              decoration: BoxDecoration(color: AppColor.white),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'No quizzes found',
                      style: GoogleFont.ibmPlexSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColor.gray,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Image.asset(AppImages.noDataFound),
                ],
              ),
            );

          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CommonContainer.NavigatArrow(
                        image: AppImages.leftSideArrow,
                        imageColor: AppColor.lightBlack,
                        container: AppColor.lowLightgray,
                        onIconTap: () => Navigator.pop(context),
                        border: Border.all(
                          color: AppColor.lightgray,
                          width: 0.3,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(() => const QuizScreenCreate());
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Create Quiz  ',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColor.blue,
                              ),
                            ),
                            SizedBox(width: 15),
                            Image.asset(AppImages.doubleArrow, height: 19),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Center(
                    child: Text(
                      'Quiz History',
                      style: GoogleFont.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Filter Chips (Class Names)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 28.0),
                          child: SizedBox(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: quizController.classNames.length,
                              itemBuilder: (context, index) {
                                final name = quizController.classNames[index];
                                final isSelected =
                                    quizController.selectedClassName.value ==
                                    name;

                                return GestureDetector(
                                  onTap: () => quizController.selectClass(name),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? AppColor.blue
                                                : AppColor.borderGary,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: buildClassNameRichText(
                                      name,
                                      isSelected
                                          ? AppColor.blue
                                          : AppColor.gray,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Grouped sections
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              groups.entries.map((entry) {
                                final dateLabel =
                                    entry.key; // 'Today' / 'Yesterday'
                                final List<QuizItem> items = entry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        dateLabel,
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 12,
                                          color: AppColor.gray,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),

                                    ...items.asMap().entries.map((e) {
                                      final int idx = e.key;
                                      final QuizItem qi = e.value;

                                      List<Color> colors = [
                                        AppColor.lightBlueC1,
                                        AppColor.lowLightYellow,
                                        AppColor.lowLightNavi,
                                        AppColor.lowLightPink,
                                      ];
                                      final bgColor =
                                          colors[idx % colors.length];

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: CommonContainer.homeworkhistory(
                                          view: 'view',
                                          onTap: () async {
                                            await quizController
                                                .quizDetailsPreviews(
                                                  classId: qi.id,
                                                );
                                            Get.to(
                                              () => const QuizDetails(
                                                revealOnOpen: true,
                                              ),
                                            );
                                          },
                                          CText1: qi.quizClass,
                                          onIconTap: () {
                                            Get.to(
                                              () => DetailsAttendHistory(
                                                quizId: qi.id,
                                                dateLabel: dateLabel,
                                              ),
                                            );
                                          },

                                          section: qi.quizClass,
                                          className: qi.quizClass,
                                          subText:
                                              '', // e.g., '${qi.attempted} attempted' if needed
                                          homeWorkText: qi.subject,
                                          homeWorkImage: '',
                                          avatarImage: '',
                                          mainText: qi.title,
                                          smaleText: '',
                                          time:
                                              DateAndTimeConvert.formatDateTime(
                                                showTime: true,
                                                showDate: false,
                                                qi.time.toString(),
                                              ),
                                          aText1: ' ',
                                          aText2: '',
                                          backRoundColor: bgColor,
                                          gradient: const LinearGradient(
                                            colors: [
                                              AppColor.black,
                                              AppColor.black,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

Widget buildClassNameRichText(String name, Color color) {
  if (name.trim().toLowerCase() == 'all') {
    return Text(
      'All',
      style: GoogleFont.ibmPlexSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  final parts = name.trim().split(' ');
  if (parts.length == 2) {
    final grade = parts[0];
    final section = parts[1];

    final numberPart = RegExp(r'\d+').stringMatch(grade) ?? '';
    final suffixPart = grade.replaceFirst(numberPart, '');

    return RichText(
      text: TextSpan(
        text: numberPart,
        style: GoogleFont.ibmPlexSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        children: [
          TextSpan(
            text: suffixPart,
            style: GoogleFont.ibmPlexSans(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          TextSpan(
            text: ' $section',
            style: GoogleFont.ibmPlexSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  return Text(
    name,
    style: GoogleFont.ibmPlexSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    ),
  );
}
