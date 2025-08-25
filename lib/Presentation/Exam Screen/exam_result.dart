import 'package:flutter/material.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'dummy.dart';

class ExamResult extends StatefulWidget {
  const ExamResult({super.key});

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  // data
  late List<List<int?>> marks; // [student][subject]
  int studentIndex = 0;
  int subjectIndex = 0;

  final List<String> students = ['Anjana', 'Arun', 'Anjana'];
  final List<String> subjects = [
    'Tamil',
    'English',
    'Mathematics',
    'Science',
    'Social Science',
  ];

  // INIT marks so 'late' has a value
  @override
  void initState() {
    super.initState();
    marks = List.generate(
      students.length,
      (_) => List<int?>.filled(subjects.length, null, growable: false),
      growable: false,
    );
  }

  int get doneCount => marks[studentIndex].where((e) => e != null).length;

  // ---- navigation helpers ----
  void _nextStudent({bool resetSubject = false}) {
    if (studentIndex < students.length - 1) {
      setState(() {
        studentIndex += 1;
        if (resetSubject) subjectIndex = 0;
      });
    }
  }

  void _prevStudent() {
    if (studentIndex > 0) {
      setState(() {
        studentIndex -= 1;
        subjectIndex = 0;
      });
    }
  }

  void _nextSubject() {
    if (subjectIndex < subjects.length - 1) {
      setState(() => subjectIndex += 1);
    } else {
      _nextStudent(resetSubject: true);
    }
  }

  void _prevSubject() {
    if (subjectIndex > 0) {
      setState(() => subjectIndex -= 1);
    }
  }

  void _typeDigit(int d) {
    final current = marks[studentIndex][subjectIndex];
    final nextText =
        (current == null || current == 0) ? '$d' : '${current.toString()}$d';
    var nextVal = int.tryParse(nextText) ?? 0;
    if (nextVal > 100) nextVal = 100;

    setState(() => marks[studentIndex][subjectIndex] = nextVal);

    final len = nextVal.toString().length;
    if (nextVal == 100 || len >= 2) {
      Future.microtask(_nextSubject);
    }
  }

  void _backspace() {
    final current = marks[studentIndex][subjectIndex];
    if (current == null || current == 0) return;
    final s = current.toString();
    final ns = (s.length <= 1) ? '0' : s.substring(0, s.length - 1);
    setState(() => marks[studentIndex][subjectIndex] = int.tryParse(ns) ?? 0);
  }

  void _clear() {
    setState(() => marks[studentIndex][subjectIndex] = 0);
  }

  Widget _numKey(String label, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: CommonContainer.pill(
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        radius: 20,
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStudent = students[studentIndex];

    return Scaffold(
      backgroundColor: AppColor.white,
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
                          MaterialPageRoute(
                            builder: (context) => MarkEntryScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'Show All',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.gray,
                            ),
                          ),
                          SizedBox(width: 8),
                          Image.asset(AppImages.historyImage, height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '18 Jul 25',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColor.gray,
                        ),
                      ),
                      TextSpan(
                        text: ' to ',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 12,
                          color: AppColor.lightgray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '23 Jul 25',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColor.gray,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  'Lorem ipsum donae Exam',
                  style: GoogleFont.ibmPlexSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: AppColor.lowLightBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SJ4958J',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    currentStudent,
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '$doneCount',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),
                            Text(
                              ' Out of ${subjects.length}',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                color: AppColor.lightgray,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            // border: Border.all(color:  Color(0xFFE8E8E8)),
                          ),
                          child: Column(
                            children: List.generate(subjects.length, (i) {
                              final isActive = i == subjectIndex;
                              final value = marks[studentIndex][i];
                              return Container(
                                padding:  EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border:
                                      i == subjects.length - 1
                                          ? null
                                          : const Border(
                                            bottom: BorderSide(
                                              color: Color(0xFFEDEDED),
                                              width: 1,
                                            ),
                                          ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        subjects[i],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              isActive
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                          color:
                                              isActive
                                                  ? Colors.black87
                                                  : Colors.black38,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      (value == null || value == 0)
                                          ? '--'
                                          : '$value',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            isActive
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                        color:
                                            isActive
                                                ? Colors.black87
                                                : Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonContainer.numberButton(
                            icon: Icons.chevron_right,
                            label: 'Next',
                            onTap: () => _nextStudent(resetSubject: true),
                          ),
                          SizedBox(height: 22),
                          CommonContainer.numberButton(
                            icon: Icons.chevron_left,
                            label: 'Prev',
                            onTap: _prevStudent,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Student',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1.05,
                          child: GridView.count(
                            crossAxisCount: 3,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            children: [
                              _numKey('1', onTap: () => _typeDigit(1)),
                              _numKey('2', onTap: () => _typeDigit(2)),
                              _numKey('3', onTap: () => _typeDigit(3)),
                              _numKey('4', onTap: () => _typeDigit(4)),
                              _numKey('5', onTap: () => _typeDigit(5)),
                              _numKey('6', onTap: () => _typeDigit(6)),
                              _numKey('7', onTap: () => _typeDigit(7)),
                              _numKey('8', onTap: () => _typeDigit(8)),
                              _numKey('9', onTap: () => _typeDigit(9)),
                              _numKey('⌫', onTap: _backspace),
                              _numKey('0', onTap: () => _typeDigit(0)),
                              _numKey('×', onTap: _clear),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonContainer.numberButton(
                            icon: Icons.keyboard_arrow_up,
                            label: 'Up',
                            onTap: _prevSubject,
                          ),
                          SizedBox(height: 22),
                          CommonContainer.numberButton(
                            icon: Icons.keyboard_arrow_down,
                            label: 'Down',
                            onTap: _nextSubject,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Subject',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
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
        ),
      ),
    );
  }
}
