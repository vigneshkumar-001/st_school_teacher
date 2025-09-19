import 'package:flutter/material.dart';
import 'package:st_teacher_app/Core/Utility/app_loader.dart';
import 'package:st_teacher_app/Presentation/Exam%20Screen/controller/exam_controller.dart';
import 'package:st_teacher_app/Presentation/Exam%20Screen/screens/result_list.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';
import '../../../Core/Utility/date_and_time_convert.dart';
import '../../../Core/Utility/google_fonts.dart';
import '../../../Core/Widgets/common_container.dart';
import 'exam_result_done.dart';
import 'package:get/get.dart';

class ExamResult extends StatefulWidget {
  final int examId;
  final String tittle;
  final String startDate;
  final String endDate;
  final bool? showCompleted; // 👈 new flag
  final int? studentId; // 👈 filter by ID if given

  const ExamResult({
    super.key,
    this.examId = 0,
    this.showCompleted, // 👈 optional
    this.studentId,
    this.tittle = "",
    this.startDate = "",
    this.endDate = "",
  });

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  final ExamController controller = Get.put(ExamController());
  late List<List<int?>> marks;
  int studentIndex = 0;
  int subjectIndex = 0;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     controller.getStudentExamList(examId: widget.examId);
  //
  //     // if (controller.announcementData.value == null) {
  //     //   controller.getAnnouncement(type: "general");
  //     // }
  //   });
  // }
  /*  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getStudentExamList(examId: widget.examId);

      if (widget.studentId != null) {
        final idx = controller.examStudent.indexWhere(
          (s) => s.id == widget.studentId,
        );
        if (idx != -1) {
          controller.currentIndex.value = idx;
        }
      }
    });
  }*/
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getStudentExamList(examId: widget.examId);

      if (widget.studentId != null) {
        int idx = controller.examStudent.indexWhere(
          (s) => s.id == widget.studentId,
        );

        // 👇 Apply filter if flag passed
        if (widget.showCompleted != null) {
          final filtered =
              controller.examStudent
                  .where((s) => s.isComplete == widget.showCompleted)
                  .toList();

          idx = filtered.indexWhere((s) => s.id == widget.studentId);
          if (idx != -1) {
            // reset full list to only filtered students
            controller.examStudent.value = filtered;
            controller.currentIndex.value = idx;
          }
        } else {
          if (idx != -1) {
            controller.currentIndex.value = idx;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }

          if (controller.examStudent.isEmpty) {
            return const Center(child: Text("No students found"));
          }
          final student = controller.examStudent[controller.currentIndex.value];
          final totalSubjects = student.marks.length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              child: Column(
                children: [
                  // --- Top bar ---
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
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ResultList(
                                    startDate: widget.startDate,
                                    endDate: widget.endDate,

                                    examId: widget.examId,
                                    tittle: widget.tittle,
                                  ),
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
                            const SizedBox(width: 8),
                            Image.asset(AppImages.historyImage, height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  // --- Date Range (static for now) ---
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: DateAndTimeConvert.shortDate(widget.startDate),
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
                          text: DateAndTimeConvert.shortDate(widget.endDate),
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 9),

                  Text(
                    widget.tittle.toUpperCase().toString() ?? '',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Student container ---
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
                                      student.admissionNo,
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student.name,
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
                                "${controller.currentIndex.value + 1}",
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black,
                                ),
                              ),
                              Text(
                                " Out of ${controller.examStudent.length}",
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 12,
                                  color: AppColor.lightgray,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

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
                                children: List.generate(
                                  controller.maxShownIndex.value +
                                      1, // Only use maxShownIndex
                                  (i) {
                                    final mark = student.marks[i];
                                    final isActive =
                                        i == controller.subjectIndex.value;

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border:
                                            i ==
                                                    controller
                                                        .maxShownIndex
                                                        .value // <-- use maxShownIndex here
                                                ? null
                                                : const Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        AppColor.lowLightgray,
                                                    width: 1,
                                                  ),
                                                ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              mark.subjectName,
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight:
                                                    isActive
                                                        ? FontWeight.w700
                                                        : FontWeight.w500,
                                                color:
                                                    isActive
                                                        ? AppColor.black
                                                        : AppColor.gray,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            mark.obtainedMarks == null
                                                ? '--'
                                                : '${mark.obtainedMarks}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                                  isActive
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                              color:
                                                  isActive
                                                      ? AppColor.black
                                                      : Colors.black38,
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
                    ),
                  ),

                  const SizedBox(height: 50),

                  // --- Controls ---
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
                              onTap: () => controller.nextStudent(),
                              // remove isDisabled
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
                              onTap: controller.previousStudent,
                            ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // Center: Numeric Keypad (unchanged, your logic)
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
                                        onTap: () => controller.typeDigit(n),
                                      );
                                    }
                                    if (i == 9) return const SizedBox.shrink();
                                    if (i == 10) {
                                      return CommonContainer.padKey(
                                        '0',
                                        onTap: () => controller.typeDigit(0),
                                      );
                                    }
                                    // last key = backspace
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () => controller.clearDigit(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          AppImages.clear,
                                          height: 10,
                                          width: 10,
                                        ),
                                      ),
                                    );
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
                              onTap: controller.prevSubject,
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
                              onTap:
                                  () => controller.nextSubject(
                                    examId: widget.examId,
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
        }),
      ),
    );

    /*return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.examStudent.isEmpty) {
            return const Center(child: Text("No students found"));
          }

          final student = controller.examStudent[controller.currentIndex.value];
          return SingleChildScrollView(
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
                                      student.admissionNo,
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.gray,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student.name,
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
                              onTap: controller.nextStudent,
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
                              onTap: controller.previousStudent,
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
          );
        }),
      ),
    );*/
  }
}
