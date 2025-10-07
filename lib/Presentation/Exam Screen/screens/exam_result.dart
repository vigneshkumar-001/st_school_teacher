import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_teacher_app/Core/Utility/custom_textfield.dart';

import '../../../Core/Utility/app_color.dart';
import '../../../Core/Utility/app_images.dart';
import '../../../Core/Utility/date_and_time_convert.dart';
import '../../../Core/Utility/google_fonts.dart';
import '../../../Core/Widgets/common_container.dart';
import '../../../Core/Utility/app_loader.dart';

import '../controller/exam_controller.dart';
import 'result_list.dart';

class ExamResult extends StatefulWidget {
  final int examId;
  final String tittle;
  final String startDate;
  final String endDate;
  final String? classs;
  final String? section;
  final bool? showCompleted; // optional filter
  final int? studentId; // optional preselect

  const ExamResult({
    super.key,
    this.examId = 0,
    this.tittle = "",
    this.startDate = "",
    this.endDate = "",
    this.showCompleted,
    this.studentId,
    this.classs,
    this.section,
  });

  @override
  State<ExamResult> createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult> {
  final ExamController controller = Get.put(ExamController());
  final ScrollController _subjectScroll = ScrollController();

  static const double _rowExtent = 48; // height of one subject row
  static const double _sepExtent = 1.0; // divider height
  double _subjectViewport = 0;

  late Worker _maxShownSub;

  @override
  void dispose() {
    _maxShownSub.dispose();
    _subjectScroll.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Keep selected row visible (Up/Down or tap)
    ever<int>(controller.subjectIndex, (_) => _scrollSelectedIntoView());

    // When "revealed" window grows (e.g., after 6), scroll just enough upward
    _maxShownSub = ever<int>(controller.maxShownIndex, (_) {
      if (!_subjectScroll.hasClients) return;

      final itemExtent = _rowExtent + _sepExtent;
      final visibleCount = (_subjectViewport / itemExtent).floor().clamp(
        1,
        999,
      );
      final lastShown = controller.maxShownIndex.value;

      // align so lastShown is visible at the bottom of the window
      final firstIndexShouldBe = (lastShown - visibleCount + 1).clamp(
        0,
        lastShown,
      );
      final target = firstIndexShouldBe * itemExtent;

      _subjectScroll.animateTo(
        target.toDouble().clamp(0.0, _subjectScroll.position.maxScrollExtent),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });

    // Ensure controller is available (idempotent)
    Get.put(ExamController());

    // Fetch data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getStudentExamList(examId: widget.examId);

      // Optional: filter+preselect by passed props
      if (widget.studentId != null) {
        int idx = controller.examStudent.indexWhere(
          (s) => s.id == widget.studentId,
        );

        if (widget.showCompleted != null) {
          final filtered =
              controller.examStudent
                  .where((s) => s.isComplete == widget.showCompleted)
                  .toList();

          idx = filtered.indexWhere((s) => s.id == widget.studentId);
          if (idx != -1) {
            controller.examStudent.value = filtered;
            controller.currentIndex.value = idx;
          }
        } else if (idx != -1) {
          controller.currentIndex.value = idx;
        }
      }
    });
  }

  /// Smoothly keeps the selected row inside the viewport.
  void _scrollSelectedIntoView() {
    if (!_subjectScroll.hasClients) return;

    final itemExtent = _rowExtent + _sepExtent;
    final index = controller.subjectIndex.value;
    final max = _subjectScroll.position.maxScrollExtent;
    final viewportPx = _subjectViewport;

    final firstVisible = (_subjectScroll.offset / itemExtent).floor();
    final lastVisible =
        (((_subjectScroll.offset + viewportPx) - 1) / itemExtent).floor();

    double targetOffset = _subjectScroll.offset;

    if (index < firstVisible) {
      targetOffset = index * itemExtent; // bring to top
    } else if (index > lastVisible) {
      final visibleCount = (viewportPx / itemExtent).floor().clamp(1, 999);
      final firstIndex = (index - visibleCount + 1).clamp(0, index);
      targetOffset = firstIndex * itemExtent; // bring into view
    } else {
      return; // already visible
    }

    _subjectScroll.animateTo(
      targetOffset.clamp(0.0, max),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  //******************************** NEW PARAMETER *******************************///
  // Keep row visible; when going down, prefer showing it at the bottom
  void _scrollSelectedPreferBottom() {
    if (!_subjectScroll.hasClients || _subjectViewport <= 0) return;

    final itemExtent = _rowExtent + _sepExtent;
    final index = controller.subjectIndex.value;
    final visibleCount = (_subjectViewport / itemExtent).floor().clamp(1, 999);
    final firstVisible = (_subjectScroll.offset / itemExtent).floor();
    final lastVisible = firstVisible + visibleCount - 1;

    double? target;
    if (index > lastVisible) {
      final firstIndex = (index - visibleCount + 1).clamp(0, index);
      target = firstIndex * itemExtent; // bring selected to bottom
    } else if (index < firstVisible) {
      target = index * itemExtent; // bring to top
    }
    if (target != null) {
      final max = _subjectScroll.position.maxScrollExtent;
      _subjectScroll.animateTo(
        target.clamp(0.0, max),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  // When going up, align the selected row to the top edge
  void _scrollSelectedPreferTop() {
    if (!_subjectScroll.hasClients || _subjectViewport <= 0) return;

    final itemExtent = _rowExtent + _sepExtent;
    final index = controller.subjectIndex.value;
    final target = (index * itemExtent).clamp(
      0.0,
      _subjectScroll.position.maxScrollExtent,
    );

    _subjectScroll.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _goUp() {
    final idx = controller.subjectIndex.value;
    if (idx > 0) {
      controller.subjectIndex.value = idx - 1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollSelectedPreferTop();
      });
    }
  }

  void _goDown() {
    final stu = controller.examStudent[controller.currentIndex.value];
    final total = stu.marks.length;
    final idx = controller.subjectIndex.value;

    if (idx < total - 1) {
      // move selection
      controller.subjectIndex.value = idx + 1;

      // ensure the new selected row is inside the built window
      if (controller.maxShownIndex.value < controller.subjectIndex.value) {
        controller.maxShownIndex.value = controller.subjectIndex.value;
      }

      // scroll AFTER the list rebuilds
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollSelectedPreferBottom();
      });
    }
  }

  //******************************** NEW PARAMETER END *******************************///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }
          final stu = controller.examStudent[controller.currentIndex.value];

          if (controller.examStudent.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              color: AppColor.white,
              child: Column(
                children: [
                  Text(
                    'No students found',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColor.gray,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image.asset(AppImages.noDataFound),
                ],
              ),
            );
          }

          final student = controller.examStudent[controller.currentIndex.value];

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
                        container: AppColor.white,
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

                  // --- Date Range ---
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
                    widget.tittle.toUpperCase(),
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 9),
                  CustomTextField.textWithSmall(
                    text: '${widget.classs.toString() ?? ''} ${widget.section.toString() ?? ''}',
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

                          // Subjects list (windowed)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            child: SizedBox(
                              // Visible area ~ 6 rows
                              height: _rowExtent * 3 + _sepExtent * 3,
                              child: LayoutBuilder(
                                builder: (_, c) {
                                  _subjectViewport = c.maxHeight;

                                  final stu =
                                      controller.examStudent[controller
                                          .currentIndex
                                          .value];

                                  final windowCount =
                                      (controller.maxShownIndex.value + 1)
                                          .clamp(0, stu.marks.length);

                                  return ListView.separated(
                                    controller: _subjectScroll,
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: stu.marks.length,
                                    separatorBuilder:
                                        (_, __) => const Divider(
                                          height: _sepExtent,
                                          color: AppColor.lowLightgray,
                                        ),
                                    itemBuilder: (_, i) {
                                      final mark = stu.marks[i];

                                      return Obx(() {
                                        final isActive =
                                            i == controller.subjectIndex.value;

                                        return GestureDetector(
                                          onTap:
                                              () =>
                                                  controller
                                                      .subjectIndex
                                                      .value = i,
                                          child: SizedBox(
                                            height: _rowExtent,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    mark.subjectName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFont.ibmPlexSans(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          isActive
                                                              ? FontWeight.w700
                                                              : FontWeight.w500,
                                                      color:
                                                          isActive
                                                              ? Colors.black
                                                              : AppColor
                                                                  .gray, // 👈 selected = black
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
                                                            ? Colors.black
                                                            : Colors
                                                                .black38, // 👈 selected = black
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                  );
                                },
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

                        // Center: Numeric Keypad (unchanged wiring to controller)
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
                                    // backspace
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
                              onTap: () {
                                controller.prevSubject();
                                _scrollSelectedIntoView();
                              },
                              // onTap: _goUp,
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
                              onTap: () {
                                controller.nextSubject(examId: widget.examId);
                                _scrollSelectedIntoView();
                              },
                              //onTap: _goDown,
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
  }
}
