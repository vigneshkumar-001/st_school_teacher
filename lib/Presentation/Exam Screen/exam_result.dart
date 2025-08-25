import 'package:flutter/material.dart';
import 'package:st_teacher_app/Presentation/Exam%20Screen/result_list.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'exam_result_done.dart';

class ExamResult extends StatefulWidget {
  const ExamResult({super.key});

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  late List<List<int?>> marks;
  int studentIndex = 0;
  int subjectIndex = 0;

  final List<String> students = ['Anjana', 'Arun', 'Bala'];
  final List<String> subjects = [
    'Tamil',
    'English',
    'Mathematics',
    'Science',
    'Social Science',
  ];

  @override
  void initState() {
    super.initState();
    marks = List.generate(
      students.length,
      (_) => List<int?>.filled(subjects.length, null),
    );
  }

  // ---------- navigation helpers ----------
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
      // last subject; don’t change student automatically.
      // Navigation will be handled after entry when all subjects are filled.
    }
  }

  void _prevSubject() {
    if (subjectIndex > 0) {
      setState(() => subjectIndex -= 1);
    }
  }

  // ---------- completion & routing ----------
  bool _allSubjectsFilledFor(int i) {
    // Treat 0 as "not entered" (same as your UI showing '--' for 0)
    return marks[i].every((v) => v != null && v != 0);
  }

  void _goToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExamResultDone()),
    );
  }

  // ---------- keypad actions ----------
  void _typeDigit(int d) {
    final current = marks[studentIndex][subjectIndex];
    final nextText =
        (current == null || current == 0) ? '$d' : '${current.toString()}$d';
    var nextVal = int.tryParse(nextText) ?? 0;
    if (nextVal > 100) nextVal = 100;

    setState(() => marks[studentIndex][subjectIndex] = nextVal);

    // If this entry completes the set (all 5 subjects have non-zero values), go next.
    if (_allSubjectsFilledFor(studentIndex)) {
      // Let UI paint the last value, then navigate.
      Future.microtask(_goToNextScreen);
      return;
    }

    // Auto-advance to next subject once 2 digits or 100
    final len = nextVal.toString().length;
    if (nextVal == 100 || len >= 2) {
      Future.microtask(_nextSubject);
    }
  }

  void _clear() {
    setState(() => marks[studentIndex][subjectIndex] = 0);
  }

  Widget _clearChip() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: _clear,
      child: Image.asset(AppImages.clear, height: 24, width: 25),
    );
  }

  int _enteredCountForStudent() {
    final row = marks[studentIndex];
    // Count only non-zero entries to match your display logic
    return row.where((v) => v != null && v != 0).length;
  }

  @override
  Widget build(BuildContext context) {
    final enteredCount = _enteredCountForStudent();
    final totalSubjects = subjects.length;

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
                            builder: (context) => ResultList(),
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

                // --- Card ---
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
                                  const SizedBox(height: 4),
                                  Text(
                                    students[studentIndex],
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
                              '$enteredCount',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),
                            Text(
                              ' Out of $totalSubjects',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 12,
                                color: AppColor.lightgray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Subjects list
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            child: Column(
                              children: List.generate(subjects.length, (i) {
                                final isActive = i == subjectIndex;
                                final value = marks[studentIndex][i];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border:
                                        i == subjects.length - 1
                                            ? null
                                            : const Border(
                                              bottom: BorderSide(
                                                color: AppColor.lowLightgray,
                                                width: 1,
                                              ),
                                            ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          subjects[i],
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 14,
                                            fontWeight:
                                                isActive
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                            color:
                                                isActive
                                                    ? AppColor.black
                                                    : AppColor.lightgray,
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
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // --- Controls (0 under 8) ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Student Next/Prev
                      Column(
                        children: [
                          CommonContainer.sidePill(
                            icon: Icons.chevron_right,
                            label: 'Next',
                            onTap: () => _nextStudent(resetSubject: true),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Student',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CommonContainer.sidePill(
                            icon: Icons.chevron_left,
                            label: 'Prev',
                            onTap: _prevStudent,
                          ),
                        ],
                      ),

                      const SizedBox(width: 16),

                      // Center keypad: 4x3 grid (1..9, [empty, 0, clear])
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, c) {
                            const cross = 3;
                            const gap = 14.0;
                            final keySize =
                                (c.maxWidth - (gap * (cross - 1))) / cross;
                            final gridH = keySize * 4 + gap * 3;

                            return SizedBox(
                              height: gridH,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: cross,
                                      mainAxisSpacing: gap,
                                      crossAxisSpacing: gap,
                                      childAspectRatio: 1,
                                    ),
                                itemCount: 12,
                                itemBuilder: (context, i) {
                                  if (i >= 0 && i <= 8) {
                                    final n = i + 1;
                                    return CommonContainer.padKey(
                                      '$n',
                                      onTap: () => _typeDigit(n),
                                    );
                                  }
                                  if (i == 9) return const SizedBox.shrink();
                                  if (i == 10) {
                                    return CommonContainer.padKey(
                                      '0',
                                      onTap: () => _typeDigit(0),
                                    );
                                  }
                                  return Center(child: _clearChip());
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Right: Subject Up/Down
                      Column(
                        children: [
                          CommonContainer.sidePill(
                            icon: Icons.keyboard_arrow_up,
                            label: 'Up',
                            onTap: _prevSubject,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Subject',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CommonContainer.sidePill(
                            icon: Icons.keyboard_arrow_down,
                            label: 'Down',
                            onTap: _nextSubject,
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
