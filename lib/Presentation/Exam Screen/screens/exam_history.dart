import 'package:flutter/material.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';
import '../../../Core/Utility/google_fonts.dart';
import '../../../Core/Widgets/common_container.dart';
import 'exam_create.dart';
import 'exam_result.dart';

class ExamHistory extends StatefulWidget {
  const ExamHistory({super.key});

  @override
  State<ExamHistory> createState() => _ExamHistoryState();
}

class _ExamHistoryState extends State<ExamHistory> {
  int index = 0;
  String selectedClassName = 'All';
  final Color defaultCardColor = AppColor.white;
  final List<String> className = ['All', 'September', 'August', 'July', 'June'];
  final List<Map<String, dynamic>> allTasks = [
    {
      'mainText': 'Lorem ipsum donae Exam',
      'subText1': '13 Jul 25 ',
      'subText2': '18 Jul 25 ',
      'subText21': '21 Jul 25 ',
      'subText3': ' 22 Jul 25 ',
      'showSubText3': true,
      'className': '7th C',
      'time': '4.30Pm',
      'screen': () => ExamResult(),
      'backRoundColor': AppColor.lightBlueC1,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'mainText': 'Lorem ipsum donae Exam',
      'subText1': '13 Jul 25 ',
      'subText2': '18 Jul 25 ',
      'subText21': '21 Jul 25 ',
      'className': '7th C',
      'time': '4.30Pm',
      'subText3': ' 22 Jul 25 ',
      'screen': () {},
      'backRoundColor': AppColor.lowLightYellow,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'mainText': 'Lorem ipsum donae Exam',
      'subText1': '13 Jul 25 ',
      'subText2': '18 Jul 25 ',
      'subText21': '21 Jul 25 ',
      'className': '7th C',
      'time': '4.30Pm',
      'screen': () {},
      'backRoundColor': AppColor.lowLightNavi,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'mainText': 'Lorem ipsum donae Exam',
      'subText1': '13 Jul 25 ',
      'subText2': '18 Jul 25 ',
      'subText21': '21 Jul 25 ',
      'className': '7th C',
      'time': '4.30Pm',
      'screen': () {},
      'backRoundColor': AppColor.lowLightPink,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    CommonContainer.NavigatArrow(
                      image: AppImages.leftSideArrow,
                      imageColor: AppColor.lightBlack,
                      container: AppColor.lowLightgray,
                      onIconTap: () => Navigator.pop(context),
                      border: Border.all(color: AppColor.lightgray, width: 0.3),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExamCreate()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Create Exam',
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
                    'Exams',
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 28.0,
                              ),
                              child: SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: className.length,
                                  itemBuilder: (context, index) {
                                    final name = className[index];
                                    final isSelected =
                                        selectedClassName == name;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedClassName = name;
                                        });
                                      },
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
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

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Column(
                                children:
                                    allTasks
                                        .where(
                                          (task) =>
                                              selectedClassName == 'All' ||
                                              (task['className']
                                                      ?.trim()
                                                      .toLowerCase() ==
                                                  selectedClassName
                                                      .trim()
                                                      .toLowerCase()),
                                        )
                                        .map((task) {
                                          assert(
                                            task['subText1'] == null ||
                                                task['subText1'] is String,
                                            'subText1 must be String',
                                          );
                                          assert(
                                            task['subText2'] == null ||
                                                task['subText2'] is String,
                                            'subText2 must be String',
                                          );
                                          assert(
                                            task['subText21'] == null ||
                                                task['subText21'] is String,
                                            'subText21 must be String',
                                          );
                                          assert(
                                            task['subText3'] == null ||
                                                task['subText3'] is String,
                                            'subText3 must be String',
                                          );
                                          assert(
                                            task['mainText'] == null ||
                                                task['mainText'] is String,
                                            'mainText must be String',
                                          );
                                          assert(
                                            task['time'] == null ||
                                                task['time'] is String,
                                            'time must be String',
                                          );
                                          assert(
                                            task['backRoundColor'] == null ||
                                                task['backRoundColor'] is Color,
                                            'backRoundColor must be Color',
                                          );
                                          assert(
                                            task['gradient'] == null ||
                                                task['gradient'] is Gradient,
                                            'gradient must be Gradient',
                                          );
                                          final Color defaultCardColor =
                                              AppColor.white;
                                          const Gradient defaultGradient =
                                              LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.transparent,
                                                ],
                                              );
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 16,
                                            ),
                                            child: CommonContainer.examHistory(
                                              subText1:
                                                  task['subText1'] as String? ??
                                                  '',
                                              subText2:
                                                  task['subText2'] as String? ??
                                                  '',
                                              subText21:
                                                  task['subText21']
                                                      as String? ??
                                                  '',
                                              subText3Text:
                                                  task['subText3'] as String?,
                                              mainText:
                                                  task['mainText'] as String? ??
                                                  '',
                                              time:
                                                  task['time'] as String? ?? '',
                                              backRoundColor:
                                                  (task['backRoundColor']
                                                      as Color?) ??
                                                  defaultCardColor,
                                              gradient:
                                                  (task['gradient']
                                                      as Gradient?) ??
                                                  defaultGradient,
                                              onIconTap: () {
                                                final screenBuilder =
                                                    task['screen']
                                                        as Widget Function()?;
                                                if (screenBuilder != null) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (_) =>
                                                              screenBuilder(),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        })
                                        .toList(),
                              ),
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
        ),
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
