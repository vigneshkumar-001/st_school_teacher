import 'package:flutter/material.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/quiz_details.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/quiz_screen_create.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Homework/homework_create.dart';

import 'details_attend_history.dart';

class QuizHistory extends StatefulWidget {
  const QuizHistory({super.key});

  @override
  State<QuizHistory> createState() => _QuizHistoryState();
}

class _QuizHistoryState extends State<QuizHistory> {
  int index = 0;
  String selectedClassName = 'All';

  final List<String> className = [
    'All',
    '7th C',
    '7th B',
    '8th A',
    '8th C',
    '9th B',
  ];

  final List<Map<String, dynamic>> allTasks = [
    {
      'subject': 'Science',
      'homeWorkText': 'Science Homework',
      'avatar': '',
      'mainText': 'Draw Single cell',
      'smaleText': '',
      'className': '7th C',
      'time': '4.30Pm',
      'subText': '0 out 50 ',
      'done': 'Done',
      'view': 'View',

      'screen1': () => DetailsAttendHistory(),

      'screen': () => QuizDetails(),
      'bgColor': AppColor.lowLightBlue,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'subject': 'Maths',
      'homeWorkText': 'Maths Homework',
      'avatar': '',
      'mainText': 'Draw Single cell',
      'smaleText': '',
      'className': '8th D',
      'time': '3.00Pm',
      'supText': '0 out 50',
      'done': 'Done',
      'view': 'View',
      'screen1': () {},
      'screen': () {},
      'bgColor': AppColor.lowLightYellow,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'subject': 'English',
      'homeWorkText': 'English Homework',
      'avatar': '',
      'mainText': 'Draw Single cell',
      'smaleText': '',
      'className': '6th B',
      'time': '1.30Pm',

      'supText': '0 out 60',

      'done': 'Done',
      'view': 'View',
      'screen1': () {},
      'screen': () {},
      'bgColor': AppColor.lowLightNavi,
      'gradient': LinearGradient(
        colors: [AppColor.black, AppColor.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'subject': 'Social Science',
      'homeWorkText': 'Social Science Homework',
      'avatar': '',
      'mainText': 'Draw Single cell',
      'smaleText': '',
      'className': '10th A',
      'time': '2.30Pm',
      'supText': '0 out 50',
      'done': 'Done',
      'view': 'View',
      'screen1': () {},
      'screen': () {},
      'bgColor': AppColor.lowLightPink,
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
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      border: Border.all(color: AppColor.lightgray, width: 0.3),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreenCreate(),
                          ),
                        );
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

                            SizedBox(height: 16),

                            Column(
                              children:
                                  allTasks
                                      .where(
                                        (task) =>
                                            selectedClassName == 'All' ||
                                            task['className']
                                                    ?.trim()
                                                    .toLowerCase() ==
                                                selectedClassName
                                                    .trim()
                                                    .toLowerCase(),
                                      )
                                      .map((task) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child:
                                              CommonContainer.homeworkhistory(CText1: '',
                                                section: task['section'] ?? '',
                                                className:
                                                    task['className'] ?? '',
                                                subText: task['subText'] ?? '',
                                                done: task['done'] ?? '',
                                                view: task['view'] ?? '',
                                                homeWorkText:
                                                    task['homeWorkText'] ?? '',
                                                homeWorkImage:
                                                    task['homeWorkImage'] ?? '',
                                                avatarImage:
                                                    (task['avatar']
                                                                ?.isNotEmpty ==
                                                            true)
                                                        ? task['avatar']
                                                        : '',
                                                mainText:
                                                    task['mainText'] ?? '',
                                                smaleText:
                                                    task['smaleText'] ?? '',
                                                time: task['time'] ?? '',

                                                aText1: ' ',
                                                aText2: '',
                                                backRoundColor:
                                                    task['bgColor'] ??
                                                    AppColor.white,
                                                gradient: task['gradient'],
                                                onTap: () {
                                                  final screenBuilder =
                                                      task['screen']
                                                          as Widget Function()?;
                                                  if (screenBuilder != null) {
                                                    final widget =
                                                        screenBuilder();
                                                    if (widget != null) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (_) => widget,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },

                                                onIconTap: () {
                                                  final screenBuilder =
                                                      task['screen1']
                                                          as Widget Function()?;
                                                  if (screenBuilder != null) {
                                                    final widget =
                                                        screenBuilder();
                                                    if (widget != null) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (_) => widget,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                        );
                                      })
                                      .toList(),
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
