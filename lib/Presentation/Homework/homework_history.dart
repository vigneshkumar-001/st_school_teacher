import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/Utility/app_loader.dart';
import 'package:st_teacher_app/Presentation/Homework/controller/create_homework_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/date_and_time_convert.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'homework_create.dart';
import 'homework_history_details.dart';
import 'package:get/get.dart';

import 'model/get_homework_response.dart';

class HomeworkHistory extends StatefulWidget {
  const HomeworkHistory({super.key});

  @override
  State<HomeworkHistory> createState() => _HomeworkHistoryState();
}

class _HomeworkHistoryState extends State<HomeworkHistory> {
  final CreateHomeworkController controller = Get.put(
    CreateHomeworkController(),
  );
  int index = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchHomeworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }
          if (controller.homeworkList.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 80),
              decoration: BoxDecoration(color: AppColor.white),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'No Homework Found',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeworkCreate(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Create Homework',
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
                      'Homework History',
                      style: GoogleFont.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 20,
                                ),
                                child: SizedBox(
                                  height: 40,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.classNames.length,
                                    itemBuilder: (context, index) {
                                      final name = controller.classNames[index];
                                      final isSelected =
                                          controller.selectedClassName.value ==
                                          name;

                                      return GestureDetector(
                                        onTap:
                                            () => controller.selectClass(name),
                                        child: Container(
                                          // styling here
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? AppColor.white
                                                      : AppColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    controller.groupedHomeworkByDate.entries.map((
                                      entry,
                                    ) {
                                      final dateLabel = entry.key;
                                      final homeworks = entry.value;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          ...homeworks.asMap().entries.map((
                                            entry,
                                          ) {
                                            final int index = entry.key;
                                            final HomeworkItem hw = entry.value;

                                            const List<Color> colors = [
                                              AppColor.lightBlueC1,
                                              AppColor.lowLightYellow,
                                              AppColor.lowLightNavi,
                                              AppColor.lowLightPink,
                                            ];

                                            final bgColor =
                                                colors[index % colors.length];

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                              child: CommonContainer.homeworkhistory(
                                                CText1: hw.classNames,
                                                onIconTap: () {
                                                  Get.to(
                                                    () =>
                                                        HomeworkHistoryDetails(
                                                          homeworkId: hw.id,
                                                        ),
                                                  );
                                                },
                                                section: hw.classNames,

                                                className: hw.classNames,
                                                subText: '',
                                                homeWorkText: hw.subject,
                                                homeWorkImage: '',
                                                avatarImage: '',
                                                mainText: hw.title,
                                                smaleText: '',
                                                time:
                                                    DateAndTimeConvert.formatDateTime(
                                                      showTime: true,
                                                      showDate: false,
                                                      hw.time.toString(),
                                                    ),
                                                aText1: ' ',
                                                aText2: '',
                                                backRoundColor: bgColor,
                                                gradient: LinearGradient(
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

  // Fallback to plain text
  return Text(
    name,
    style: GoogleFont.ibmPlexSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    ),
  );
}
