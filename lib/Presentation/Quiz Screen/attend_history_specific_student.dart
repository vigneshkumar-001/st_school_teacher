/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/custom_textfield.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'controller/quiz_controller.dart';

class AttendHistorySpecificStudent extends StatefulWidget {
  final String studentName;
  final int? classId; // optional: auto-load if provided
  final bool revealOnOpen; // <-- NEW

  const AttendHistorySpecificStudent({
    super.key,
    this.studentName = '',
    this.classId,
    this.revealOnOpen = false, // keeps old calls working
  });

  @override
  State<AttendHistorySpecificStudent> createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<AttendHistorySpecificStudent> {
  Map<int, String> selectedAnswers = {};
  int questionIndex = 0;
  int selectedAnswerIndexQ1 = -1;
  int selectedAnswerIndexQ2 = -1;
  bool isQuizCompleted = false;
  final QuizController quizController = Get.put(QuizController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.studentName.isEmpty ? '' : '${widget.studentName}';

    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          if (quizController.isLoading.value) {
            return Center(child: AppLoader.circularLoader(AppColor.black));
          }

          final groups = quizController.groupedQuizzes;
          final hasData = groups.isNotEmpty;

          if (!hasData) {
            return Center(child: Text("No quizzes found"));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonContainer.NavigatArrow(
                    image: AppImages.leftSideArrow,
                    imageColor: AppColor.lightBlack,
                    container: AppColor.lowLightgray,
                    onIconTap: () => Navigator.pop(context),
                    border: Border.all(color: AppColor.lightgray, width: 0.3),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titleText, // <-- dynamic title
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.blue,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Quiz Details', // <-- dynamic title
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 16,
                          color: AppColor.gray,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Obx(
                      () => Text(
                        quizController.quizDetails.value!.title,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          CustomTextField.quizQuestion(
                            sno: '1.',
                            text: 'What is 7 + 6?',
                          ),
                          const SizedBox(height: 15),
                          CommonContainer.quizContainer(
                            isQuizCompleted: isQuizCompleted,
                            leftTextNumber: 'A',
                            leftValue: '11',
                            rightTextNumber: 'B',
                            rightValue: "12",
                            leftSelected: selectedAnswerIndexQ1 == 0,
                            rightSelected: selectedAnswerIndexQ1 == 1,
                            leftOnTap:
                                () => setState(() => selectedAnswerIndexQ1 = 0),
                            rightOnTap:
                                () => setState(() => selectedAnswerIndexQ1 = 1),
                          ),
                          const SizedBox(height: 20),
                          CommonContainer.quizContainer(
                            isQuizCompleted: isQuizCompleted,
                            leftTextNumber: 'C',
                            leftValue: '13',
                            rightTextNumber: 'D',
                            rightValue: "14",
                            leftSelected: selectedAnswerIndexQ1 == 2,
                            rightSelected: selectedAnswerIndexQ1 == 3,
                            leftOnTap:
                                () => setState(() => selectedAnswerIndexQ1 = 2),
                            rightOnTap:
                                () => setState(() => selectedAnswerIndexQ1 = 3),
                          ),
                          const SizedBox(height: 35),
                          CustomTextField.quizQuestion(
                            sno: '2.',
                            text: 'What is the value of 5 × 3?',
                          ),
                          const SizedBox(height: 15),
                          CommonContainer.quizContainer(
                            isQuizCompleted: isQuizCompleted,
                            leftTextNumber: 'A',
                            leftValue: '11',
                            rightTextNumber: 'B',
                            rightValue: "12",
                            leftSelected: selectedAnswerIndexQ2 == 0,
                            rightSelected: selectedAnswerIndexQ2 == 1,
                            leftOnTap:
                                () => setState(() => selectedAnswerIndexQ2 = 0),
                            rightOnTap:
                                () => setState(() => selectedAnswerIndexQ2 = 1),
                          ),
                          const SizedBox(height: 20),
                          CommonContainer.quizContainer(
                            isQuizCompleted: isQuizCompleted,
                            leftSelected: selectedAnswerIndexQ2 == 2,
                            rightSelected: selectedAnswerIndexQ2 == 3,
                            leftTextNumber: 'C',
                            leftValue: '13',
                            rightTextNumber: 'D',
                            rightValue: "14",
                            leftOnTap:
                                () => setState(() => selectedAnswerIndexQ2 = 2),
                            rightOnTap:
                                () => setState(() => selectedAnswerIndexQ2 = 3),
                          ),
                          const SizedBox(height: 35),
                          CustomTextField.quizQuestion(
                            sno: '3.',
                            text:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                          ),
                          const SizedBox(height: 20),
                          CommonContainer.quizContainer1(
                            isQuizCompleted: isQuizCompleted,
                            isSelected: selectedAnswers[questionIndex] == 'A',
                            onTap:
                                () => setState(
                                  () => selectedAnswers[questionIndex] = 'A',
                                ),
                            leftTextNumber: 'A',
                            leftValue:
                                'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                          ),
                          const SizedBox(height: 20),
                          CommonContainer.quizContainer1(
                            isQuizCompleted: isQuizCompleted,
                            isSelected: selectedAnswers[questionIndex] == 'B',
                            onTap:
                                () => setState(
                                  () => selectedAnswers[questionIndex] = 'B',
                                ),
                            leftTextNumber: 'B',
                            leftValue:
                                'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                          ),
                          const SizedBox(height: 20),
                          CommonContainer.quizContainer1(
                            isQuizCompleted: isQuizCompleted,
                            isSelected: selectedAnswers[questionIndex] == 'C',
                            onTap:
                                () => setState(
                                  () => selectedAnswers[questionIndex] = 'C',
                                ),
                            leftTextNumber: 'C',
                            leftValue:
                                'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                          ),
                          const SizedBox(height: 20),
                          CommonContainer.quizContainer1(
                            isQuizCompleted: isQuizCompleted,
                            isSelected: selectedAnswers[questionIndex] == 'D',
                            onTap:
                                () => setState(
                                  () => selectedAnswers[questionIndex] = 'D',
                                ),
                            leftTextNumber: 'D',
                            leftValue:
                                'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 25,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.black.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ListTile(
                        leading: Image.asset(AppImages.clock, height: 33),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Posted on',
                              style: GoogleFont.inter(
                                fontSize: 10,
                                color: AppColor.gray,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '4.30Pm',
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.black,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '18.Jul.25',
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    color: AppColor.gray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
}*/

/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/custom_textfield.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'Model/details_preview.dart';
import 'controller/quiz_controller.dart';


class AttendHistorySpecificStudent extends StatefulWidget {
  final String studentName;
  final int? classId; // optional: auto-load if provided
  final bool revealOnOpen;

  const AttendHistorySpecificStudent({
    super.key,
    this.studentName = '',
    this.classId,
    this.revealOnOpen = false,
  });

  @override
  State<AttendHistorySpecificStudent> createState() => _AttendHistorySpecificStudentState();
}

class _AttendHistorySpecificStudentState extends State<AttendHistorySpecificStudent> {
  final QuizController quizController = Get.put(QuizController());

  @override
  void initState() {
    super.initState();
    // No selection / reveal logic. We only highlight by isCorrect.
  }

  // ---------- small helpers ----------
  bool _isShort(String s) {
    final t = s.trim();
    return t.length <= 30 && !t.contains('\n');
  }

  bool _isNumeric(String s) {
    final t = s.trim();
    final numeric = RegExp(r'^[-+]?\d+(\.\d+)?$');
    return numeric.hasMatch(t);
  }

  /// Convert "2025-09-01" -> "01.Sep.2025"
  String _formatApiDate(String yMd) {
    try {
      final d = DateTime.parse(yMd); // supports "yyyy-MM-dd"
      return DateFormat('dd.MMM.yyyy').format(d);
    } catch (_) {
      return yMd; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final titlePrefix = widget.studentName.isEmpty ? '' : '${widget.studentName} ';

    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          if (quizController.isLoading.value &&
              quizController.quizDetails.value == null) {
            return Center(child: AppLoader.circularLoader(AppColor.black));
          }

          final details = quizController.quizDetails.value;
          if (details == null) {
            return const Center(child: Text('No quiz details found'));
          }

          final postedTime = details.time; // e.g. "12:04 PM"
          final postedDate = _formatApiDate(details.date); // e.g. "01.Sep.2025"

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonContainer.NavigatArrow(
                    image: AppImages.leftSideArrow,
                    imageColor: AppColor.lightBlack,
                    container: AppColor.lowLightgray,
                    onIconTap: () => Navigator.pop(context),
                    border: Border.all(color: AppColor.lightgray, width: 0.3),
                  ),
                  const SizedBox(height: 35),

                  // Header line: "<Student> Quiz Details"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        titlePrefix,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.blue,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Quiz Details',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 16,
                          color: AppColor.gray,
                        ),
                      ),
                    ],
                  ),

                  // Title from API
                  Center(
                    child: Text(
                      details.title, // ex: "Math Quiz 1"
                      textAlign: TextAlign.center,
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Questions
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          ...List.generate(details.questions.length, (qIdx) {
                            final q = details.questions[qIdx];
                            final number = '${qIdx + 1}.';

                            // ✅ Strongly type options
                            final List<Option> options = q.options;

                            final allNumeric = options.isNotEmpty &&
                                options.every((o) => _isNumeric(o.text));
                            final anyParagraph =
                            options.any((o) => !_isShort(o.text));
                            final useTwoUp = allNumeric && !anyParagraph;

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: qIdx == details.questions.length - 1 ? 0 : 28,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField.quizQuestion(
                                    sno: number,
                                    text: q.text,
                                  ),
                                  const SizedBox(height: 15),

                                  if (useTwoUp)
                                  // numeric/compact -> 2 per row
                                    ...List.generate((options.length / 2).ceil(), (row) {
                                      final leftIdx = row * 2;
                                      final rightIdx = leftIdx + 1;

                                      final Option left = options[leftIdx];
                                      final bool hasRight = rightIdx < options.length;
                                      final Option? right = hasRight ? options[rightIdx] : null;

                                      final leftLetter  = String.fromCharCode(65 + leftIdx);
                                      final rightLetter = hasRight ? String.fromCharCode(65 + rightIdx) : '';

                                      // ✅ borders: green for correct; gray otherwise
                                      final leftBorderColor = (left.isCorrect == true)
                                          ? AppColor.green
                                          : AppColor.lowLightgray;

                                      final rightBorderColor = hasRight
                                          ? ((right!.isCorrect == true)
                                          ? AppColor.green
                                          : AppColor.lowLightgray)
                                          : Colors.transparent;

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: row == ((options.length / 2).ceil() - 1) ? 0 : 14,
                                        ),
                                        child: CommonContainer.quizContainer(
                                          leftTextNumber: leftLetter,
                                          leftValue: left.text,
                                          rightTextNumber: hasRight ? rightLetter : '',
                                          rightValue: hasRight ? right!.text : '',
                                          // 🚫 selection OFF
                                          leftSelected: false,
                                          rightSelected: false,
                                          isQuizCompleted: false,
                                          // ✅ borders by correctness
                                          leftBorderColor: leftBorderColor,
                                          rightBorderColor: rightBorderColor,
                                          // 🚫 taps OFF
                                          leftOnTap: null,
                                          rightOnTap: null,
                                        ),
                                      );
                                    })
                                  else
                                  // text/paragraph/mixed -> full width items
                                    ...List.generate(options.length, (oIdx) {
                                      final Option opt = options[oIdx];
                                      final letter = String.fromCharCode(65 + oIdx);

                                      final borderColor = (opt.isCorrect == true)
                                          ? AppColor.green
                                          : AppColor.lowLightgray;

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: oIdx == options.length - 1 ? 0 : 14,
                                        ),
                                        child: CommonContainer.quizContainer1(
                                          // 🚫 selection OFF
                                          isQuizCompleted: false,
                                          isSelected: false,
                                          onTap: null,
                                          leftTextNumber: letter,
                                          leftValue: opt.text,
                                          borderColor: borderColor,
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Posted on (time + date from API)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.black.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ListTile(
                        leading: Image.asset(AppImages.clock, height: 33),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Posted on',
                              style: GoogleFont.inter(
                                fontSize: 10,
                                color: AppColor.gray,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  postedTime,
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.black,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  postedDate,
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    color: AppColor.gray,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/Model/history_specific_student_response.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/custom_textfield.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';

import 'controller/quiz_controller.dart';

class AttendHistorySpecificStudent extends StatefulWidget {
  final String studentName; // optional display override
  final int quizId; // optional if you autoload by class/quiz id
  final bool revealOnOpen;
  final int studentId;

  const AttendHistorySpecificStudent({
    super.key,
    this.studentName = '',
    required this.quizId,
    required this.studentId,
    this.revealOnOpen = false,
  });

  @override
  State<AttendHistorySpecificStudent> createState() =>
      _AttendHistorySpecificStudentState();
}

class _AttendHistorySpecificStudentState
    extends State<AttendHistorySpecificStudent> {
  final QuizController c = Get.put(QuizController());

  @override
  void initState() {
    super.initState();
    AppLogger.log.i('${widget.quizId},${widget.studentId}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.loadStudentQuizResult(quizId: 11, studentId: 2450);

      setState(() {});
    });
  }

  bool _isShort(String s) {
    final t = s.trim();
    return t.length <= 30 && !t.contains('\n');
  }

  bool _isNumeric(String s) {
    final t = s.trim();
    final numeric = RegExp(r'^[-+]?\d+(\.\d+)?$');
    return numeric.hasMatch(t);
  }

  Color _borderFor(SQOption o) {
    if (o.isCorrect) return AppColor.green;
    if (o.selected) return Colors.red;
    return AppColor.lowLightgray;
  }

  String _letter(int i) => String.fromCharCode(65 + i); // A, B, C...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          final data = c.studentQuiz.value; // StudentQuizData?

          if (c.isLoading.value && data == null) {
            return Center(child: AppLoader.circularLoader(AppColor.black));
          }

          if (data == null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CommonContainer.NavigatArrow(
                    image: AppImages.leftSideArrow,
                    imageColor: AppColor.lightBlack,
                    container: AppColor.lowLightgray,
                    onIconTap: () => Navigator.pop(context),
                    border: Border.all(color: AppColor.lightgray, width: 0.3),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'No quiz data found',
                    style: GoogleFont.ibmPlexSans(fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // ✅ Now `data` is non-null StudentQuizData
          final displayName =
              widget.studentName.isNotEmpty
                  ? widget.studentName
                  : data.student.name;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonContainer.NavigatArrow(
                    image: AppImages.leftSideArrow,
                    imageColor: AppColor.lightBlack,
                    container: AppColor.lowLightgray,
                    onIconTap: () => Navigator.pop(context),
                    border: Border.all(color: AppColor.lightgray, width: 0.3),
                  ),
                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayName,
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.blue,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Quiz Details',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 16,
                          color: AppColor.gray,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      data.quiz.title,
                      textAlign: TextAlign.center,
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ),

                  // const SizedBox(height: 10),
                  // Center(
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 14,
                  //       vertical: 8,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: AppColor.white,
                  //       borderRadius: BorderRadius.circular(30),
                  //       border: Border.all(
                  //         color: AppColor.lightgray,
                  //         width: 0.5,
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'Score: ${data.score}/${data.total}',
                  //       style: GoogleFont.inter(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  //
                  // const SizedBox(height: 16),
                  // Center(
                  //   child: Wrap(
                  //     spacing: 12,
                  //     runSpacing: 8,
                  //     crossAxisAlignment: WrapCrossAlignment.center,
                  //     children: [
                  //       _legendDot(border: AppColor.green, label: 'Correct'),
                  //       _legendDot(
                  //         border: Colors.red,
                  //         label: 'Your wrong pick',
                  //       ),
                  //       _legendDot(
                  //         border: AppColor.lowLightgray,
                  //         label: 'Other options',
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 25),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: List.generate(data.questions.length, (qIdx) {
                          final q = data.questions[qIdx];
                          final number = '${qIdx + 1}.';

                          final options = q.options;
                          final allNumeric =
                              options.isNotEmpty &&
                              options.every((o) => _isNumeric(o.text));
                          final anyLongText = options.any(
                            (o) => !_isShort(o.text),
                          );
                          final useTwoUp = allNumeric && !anyLongText;

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  qIdx == data.questions.length - 1 ? 0 : 28,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField.quizQuestion(
                                  sno: number,
                                  text: q.text,
                                ),
                                const SizedBox(height: 15),

                                if (useTwoUp)
                                  ...List.generate(
                                    (options.length / 2).ceil(),
                                    (row) {
                                      final leftIdx = row * 2;
                                      final rightIdx = leftIdx + 1;

                                      final left = options[leftIdx];
                                      final hasRight =
                                          rightIdx < options.length;
                                      final right =
                                          hasRight ? options[rightIdx] : null;

                                      final leftLetter = _letter(leftIdx);
                                      final rightLetter =
                                          hasRight ? _letter(rightIdx) : '';

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                              row ==
                                                      ((options.length / 2)
                                                              .ceil() -
                                                          1)
                                                  ? 0
                                                  : 14,
                                        ),
                                        child: CommonContainer.quizContainer(
                                          leftTextNumber: leftLetter,
                                          leftValue: left.text,
                                          rightTextNumber:
                                              hasRight ? rightLetter : '',
                                          rightValue:
                                              hasRight ? right!.text : '',
                                          leftSelected: left.selected,
                                          rightSelected:
                                              right?.selected ?? false,
                                          isQuizCompleted: true,
                                          leftBorderColor: _borderFor(left),
                                          rightBorderColor:
                                              hasRight
                                                  ? _borderFor(right!)
                                                  : Colors.transparent,
                                          leftOnTap: null,
                                          rightOnTap: null,
                                        ),
                                      );
                                    },
                                  )
                                else
                                  ...List.generate(options.length, (oIdx) {
                                    final opt = options[oIdx];
                                    final letter = _letter(oIdx);
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            oIdx == options.length - 1 ? 0 : 14,
                                      ),
                                      child: CommonContainer.quizContainer1(
                                        isQuizCompleted: true,
                                        isSelected: opt.selected,
                                        onTap: null,
                                        leftTextNumber: letter,
                                        leftValue: opt.text,
                                        borderColor: _borderFor(opt),
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _legendDot({required Color border, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border, width: 2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFont.inter(fontSize: 11, color: AppColor.gray),
        ),
      ],
    );
  }
}
