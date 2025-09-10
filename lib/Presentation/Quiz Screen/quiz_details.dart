/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/custom_textfield.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'controller/quiz_controller.dart';

class QuizDetails extends StatefulWidget {
  final String studentName; // <-- NEW

  const QuizDetails({
    super.key,
    this.studentName = '', // keeps old calls working
  });

  @override
  State<QuizDetails> createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
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
}
*/
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../../Core/Utility/app_color.dart';
// import '../../Core/Utility/app_images.dart';
// import '../../Core/Utility/app_loader.dart';
// import '../../Core/Utility/custom_textfield.dart';
// import '../../Core/Utility/google_fonts.dart';
// import '../../Core/Widgets/common_container.dart';
// import 'controller/quiz_controller.dart';
//
// class QuizDetails extends StatefulWidget {
//   final String studentName;
//   final int? classId; // optional: auto-load if provided
//   final bool revealOnOpen;
//
//
//   const QuizDetails({
//     super.key,
//     this.studentName = '',
//     this.classId,
//     this.revealOnOpen = false,
//
//   });
//
//   @override
//   State<QuizDetails> createState() => _QuizDetailsState();
// }
//
// class _QuizDetailsState extends State<QuizDetails> {
//   /// Track selected option index per questionId
//   final Map<int, int> selectedOptionIndex = {};
//   final QuizController quizController = Get.put(QuizController());
//
//   /// Toggle this to true when you submit/finish the quiz
//   bool isQuizCompleted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) setState(() => isQuizCompleted = true);
//     });
//   }
//
//   bool _isShort(String s) {
//     final t = s.trim();
//     return t.length <= 30 && !t.contains('\n');
//   }
//
//   bool _isNumeric(String s) {
//     final t = s.trim();
//     final numeric = RegExp(r'^[-+]?\d+(\.\d+)?$');
//     return numeric.hasMatch(t);
//   }
//
//   /// Decide border color for any option considering completion + correctness
//   Color _getOptionBorderColor({
//     required int qId,
//     required int optionIndex,
//     required bool isSelected,
//     required int? correctIndex,
//   }) {
//     if (!isQuizCompleted) {
//       // Normal quiz mode: highlight just the selected
//       return isSelected ? AppColor.green : AppColor.lowLightgray;
//     }
//
//     // Completed mode: show correctness
//     if (correctIndex != null) {
//       if (optionIndex == correctIndex) return AppColor.green; // correct
//       if (isSelected && optionIndex != correctIndex)
//         return Colors.red; // wrong attempt
//     }
//     return AppColor.lowLightgray;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final titlePrefix =
//         widget.studentName.isEmpty ? '' : '${widget.studentName} ';
//
//     return Scaffold(
//       backgroundColor: AppColor.lowLightgray,
//       body: SafeArea(
//         child: Obx(() {
//           if (quizController.isLoading.value &&
//               quizController.quizDetails.value == null) {
//             return Center(child: AppLoader.circularLoader(AppColor.black));
//           }
//
//           final details = quizController.quizDetails.value;
//           if (details == null) {
//             return const Center(child: Text('No quiz details found'));
//           }
//
//           final postedTime = details.time; // e.g. "3:56 PM"
//           final postedDate = _formatApiDate(details.date); // e.g. "29.Aug.2025"
//
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CommonContainer.NavigatArrow(
//                     image: AppImages.leftSideArrow,
//                     imageColor: AppColor.lightBlack,
//                     container: AppColor.lowLightgray,
//                     onIconTap: () => Navigator.pop(context),
//                     border: Border.all(color: AppColor.lightgray, width: 0.3),
//                   ),
//                   const SizedBox(height: 35),
//
//                   // Header line: "<Student> Quiz Details"
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         titlePrefix,
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColor.blue,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Quiz Details',
//                         style: GoogleFont.ibmPlexSans(
//                           fontSize: 16,
//                           color: AppColor.gray,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   // Title from API
//                   Center(
//                     child: Text(
//                       details.title, // e.g. "Math Quiz 1"
//                       textAlign: TextAlign.center,
//                       style: GoogleFont.ibmPlexSans(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w600,
//                         color: AppColor.black,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   // Questions
//                   Container(
//                     decoration: BoxDecoration(
//                       color: AppColor.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                         children: [
//                           ...List.generate(details.questions.length, (qIdx) {
//                             final q = details.questions[qIdx];
//                             final qId =
//                                 (q.id is int)
//                                     ? q.id as int
//                                     : qIdx; // fallback id
//                             final number = '${qIdx + 1}.';
//
//                             // SAFELY derive correct index from either question or options
//                             final options = q.options;
//                             final int? correctIndex = _deriveCorrectIndex(
//                               q,
//                               options,
//                             );
//
//                             final allNumeric =
//                                 options.isNotEmpty &&
//                                 options.every((o) => _isNumeric(o.text));
//                             final anyParagraph = options.any(
//                               (o) => !_isShort(o.text),
//                             );
//
//                             final useTwoUp = allNumeric && !anyParagraph;
//
//                             return Padding(
//                               padding: EdgeInsets.only(
//                                 bottom:
//                                     qIdx == details.questions.length - 1
//                                         ? 0
//                                         : 28,
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomTextField.quizQuestion(
//                                     sno: number,
//                                     text: q.text,
//                                   ),
//                                   const SizedBox(height: 15),
//
//                                   if (useTwoUp)
//                                     // Numeric, compact -> two per row
//                                     ...List.generate((options.length / 2).ceil(), (
//                                       row,
//                                     ) {
//                                       final leftIdx = row * 2;
//                                       final rightIdx = leftIdx + 1;
//
//                                       final left = options[leftIdx];
//                                       final leftLetter = String.fromCharCode(
//                                         65 + leftIdx,
//                                       );
//                                       final leftSelected =
//                                           selectedOptionIndex[qId] == leftIdx;
//
//                                       final hasRight =
//                                           rightIdx < options.length;
//                                       final right =
//                                           hasRight ? options[rightIdx] : null;
//                                       final rightLetter =
//                                           hasRight
//                                               ? String.fromCharCode(
//                                                 65 + rightIdx,
//                                               )
//                                               : '';
//
//                                       final rightSelected =
//                                           hasRight
//                                               ? (selectedOptionIndex[qId] ==
//                                                   rightIdx)
//                                               : false;
//
//                                       // compute border colors (completed state aware)
//                                       final leftBorderColor =
//                                           _getOptionBorderColor(
//                                             qId: qId,
//                                             optionIndex: leftIdx,
//                                             isSelected: leftSelected,
//                                             correctIndex: correctIndex,
//                                           );
//                                       final rightBorderColor =
//                                           hasRight
//                                               ? _getOptionBorderColor(
//                                                 qId: qId,
//                                                 optionIndex: rightIdx,
//                                                 isSelected: rightSelected,
//                                                 correctIndex: correctIndex,
//                                               )
//                                               : Colors.transparent;
//
//                                       return Padding(
//                                         padding: EdgeInsets.only(
//                                           bottom:
//                                               row ==
//                                                       ((options.length / 2)
//                                                               .ceil() -
//                                                           1)
//                                                   ? 0
//                                                   : 14,
//                                         ),
//                                         child: CommonContainer.quizContainer(
//                                           leftTextNumber: leftLetter,
//                                           leftValue: left.text,
//                                           rightTextNumber:
//                                               hasRight ? rightLetter : '',
//                                           rightValue:
//                                               hasRight ? right!.text : '',
//                                           leftSelected: leftSelected,
//                                           rightSelected: rightSelected,
//                                           isQuizCompleted: isQuizCompleted,
//                                           leftBorderColor: leftBorderColor,
//                                           rightBorderColor: rightBorderColor,
//                                           leftOnTap:
//                                               () => setState(
//                                                 () =>
//                                                     selectedOptionIndex[qId] =
//                                                         leftIdx,
//                                               ),
//                                           rightOnTap:
//                                               hasRight
//                                                   ? () => setState(
//                                                     () =>
//                                                         selectedOptionIndex[qId] =
//                                                             rightIdx,
//                                                   )
//                                                   : null, // placeholder -> transparent
//                                         ),
//                                       );
//                                     })
//                                   else
//                                     // Text/paragraph/mixed -> full width
//                                     ...List.generate(options.length, (oIdx) {
//                                       final opt = options[oIdx];
//                                       final isSelected =
//                                           selectedOptionIndex[qId] == oIdx;
//                                       final letter = String.fromCharCode(
//                                         65 + oIdx,
//                                       );
//
//                                       final borderColor = _getOptionBorderColor(
//                                         qId: qId,
//                                         optionIndex: oIdx,
//                                         isSelected: isSelected,
//                                         correctIndex: correctIndex,
//                                       );
//
//                                       return Padding(
//                                         padding: EdgeInsets.only(
//                                           bottom:
//                                               oIdx == options.length - 1
//                                                   ? 0
//                                                   : 14,
//                                         ),
//                                         child: CommonContainer.quizContainer1(
//                                           isQuizCompleted: isQuizCompleted,
//                                           isSelected: isSelected,
//                                           onTap: () {
//                                             setState(
//                                               () =>
//                                                   selectedOptionIndex[qId] =
//                                                       oIdx,
//                                             );
//                                           },
//                                           leftTextNumber: letter,
//                                           leftValue: opt.text,
//                                           borderColor: borderColor,
//                                         ),
//                                       );
//                                     }),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 25),
//
//                   // Posted on (time + date from API)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 64,
//                       vertical: 25,
//                     ),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: AppColor.black.withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: ListTile(
//                         leading: Image.asset(AppImages.clock, height: 33),
//                         title: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Posted on',
//                               style: GoogleFont.inter(
//                                 fontSize: 10,
//                                 color: AppColor.gray,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 Text(
//                                   postedTime,
//                                   style: GoogleFont.inter(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColor.black,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Text(
//                                   postedDate,
//                                   style: GoogleFont.inter(
//                                     fontSize: 12,
//                                     color: AppColor.gray,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   /// Convert "2025-08-29" -> "29.Aug.2025"
//   String _formatApiDate(String yMd) {
//     try {
//       final d = DateTime.parse(yMd); // supports "yyyy-MM-dd"
//       return DateFormat('dd.MMM.yyyy').format(d);
//     } catch (_) {
//       return yMd; // fallback
//     }
//   }
//
//   // -------- Correct-answer derivation helpers --------
//
//   /// Try to find the correct option index (0-based) from question or options.
//   /// Supports a variety of common backend field names and normalizes 1-based indexes.
//   int? _deriveCorrectIndex(dynamic question, List<dynamic> options) {
//     // 1) Question-level integer keys (index)
//     final idxFromQuestion = _readFirstInt(question, const [
//       'correctIndex',
//       'answerIndex',
//       'correct_option_index',
//       'correct_option',
//       'correct', // some APIs store 1-based index here
//       'answer',
//     ]);
//     if (idxFromQuestion != null) {
//       return _normalizeIndex(idxFromQuestion, options.length);
//     }
//
//     // 2) Option-level flags (one of the options marked correct)
//     for (var i = 0; i < options.length; i++) {
//       final opt = options[i];
//
//       // common boolean flags
//       final flag = _readFirstBool(opt, const [
//         'isCorrect',
//         'correct',
//         'is_true',
//         'isTrue',
//         'is_answer',
//         'is_correct',
//       ]);
//       if (flag == true) return i;
//
//       // sometimes numeric flags (1/0) live under these keys
//       final numLike = _readFirstInt(opt, const ['value', 'status', 'answer']);
//       if (numLike != null && numLike != 0) return i;
//     }
//
//     // 3) Could not determine
//     return null;
//   }
//
//   /// Accept both 0-based and 1-based indices and clamp invalid values to null.
//   int? _normalizeIndex(int raw, int len) {
//     if (raw >= 0 && raw < len) return raw; // already 0-based
//     final oneBased = raw - 1; // treat as 1-based
//     if (oneBased >= 0 && oneBased < len) return oneBased;
//     return null;
//   }
//
//   /// Read first present INT among keys from a Map-like or object (via toJson).
//   int? _readFirstInt(dynamic obj, List<String> keys) {
//     for (final k in keys) {
//       final v = _readField(obj, k);
//       if (v is int) return v;
//       if (v is num) return v.toInt();
//       if (v is String) {
//         final p = int.tryParse(v.trim());
//         if (p != null) return p;
//       }
//     }
//     return null;
//   }
//
//   /// Read first present BOOL among keys (accepts bool / 0/1 / "true"/"false").
//   bool? _readFirstBool(dynamic obj, List<String> keys) {
//     for (final k in keys) {
//       final v = _readField(obj, k);
//       final b = _asBool(v);
//       if (b != null) return b;
//     }
//     return null;
//   }
//
//   bool? _asBool(dynamic v) {
//     if (v is bool) return v;
//     if (v is num) return v != 0;
//     if (v is String) {
//       final t = v.trim().toLowerCase();
//       if (t == 'true' || t == '1' || t == 'yes') return true;
//       if (t == 'false' || t == '0' || t == 'no') return false;
//     }
//     return null;
//   }
//
//   /// Safely read a field by key from Map or from object.toJson()
//   dynamic _readField(dynamic obj, String key) {
//     try {
//       if (obj is Map) return obj[key];
//       final m = (obj as dynamic).toJson?.call();
//       if (m is Map) return m[key];
//     } catch (_) {}
//     return null;
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/custom_textfield.dart';
import '../../Core/Utility/date_and_time_convert.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'Model/details_preview.dart';
import 'controller/quiz_controller.dart';

class QuizDetails extends StatefulWidget {
  final String studentName;
  final int? classId;
  final bool revealOnOpen;

  const QuizDetails({
    super.key,
    this.studentName = '',
    this.classId,
    this.revealOnOpen = false,
  });

  @override
  State<QuizDetails> createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  final QuizController quizController = Get.put(QuizController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      quizController.quizDetailsPreviews(classId: widget.classId ?? 0);
    });
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
    final titlePrefix =
        widget.studentName.isEmpty ? '' : '${widget.studentName} ';

    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          if (quizController.quizDetailsPreview.value) {
            return Center(child: AppLoader.circularLoader());
          }

          final details = quizController.quizDetails.value;
          if (details == null) {
            return const Center(child: Text('No quiz details found'));
          }

          // final postedTime = details.time; // e.g. "12:04 PM"
          // final postedDate = _formatApiDate(details.date); // e.g. "01.Sep.2025"

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

                            final allNumeric =
                                options.isNotEmpty &&
                                options.every((o) => _isNumeric(o.text));
                            final anyParagraph = options.any(
                              (o) => !_isShort(o.text),
                            );
                            final useTwoUp = allNumeric && !anyParagraph;

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    qIdx == details.questions.length - 1
                                        ? 0
                                        : 28,
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
                                    ...List.generate(
                                      (options.length / 2).ceil(),
                                      (row) {
                                        final leftIdx = row * 2;
                                        final rightIdx = leftIdx + 1;

                                        final Option left = options[leftIdx];
                                        final bool hasRight =
                                            rightIdx < options.length;
                                        final Option? right =
                                            hasRight ? options[rightIdx] : null;

                                        final leftLetter = String.fromCharCode(
                                          65 + leftIdx,
                                        );
                                        final rightLetter =
                                            hasRight
                                                ? String.fromCharCode(
                                                  65 + rightIdx,
                                                )
                                                : '';

                                        // ✅ borders: green for correct; gray otherwise
                                        final leftBorderColor =
                                            (left.isCorrect == true)
                                                ? AppColor.green
                                                : AppColor.lowLightgray;

                                        final rightBorderColor =
                                            hasRight
                                                ? ((right!.isCorrect == true)
                                                    ? AppColor.green
                                                    : AppColor.lowLightgray)
                                                : Colors.transparent;

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
                                      },
                                    )
                                  else
                                    // text/paragraph/mixed -> full width items
                                    ...List.generate(options.length, (oIdx) {
                                      final Option opt = options[oIdx];
                                      final letter = String.fromCharCode(
                                        65 + oIdx,
                                      );

                                      final borderColor =
                                          (opt.isCorrect == true)
                                              ? AppColor.green
                                              : AppColor.lowLightgray;

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                              oIdx == options.length - 1
                                                  ? 0
                                                  : 14,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64,
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
                                  DateAndTimeConvert.formatDateTime(
                                    showTime: true,
                                    showDate: false,
                                    details.time.toString(),
                                  ),
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.black,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  DateAndTimeConvert.formatDateTime(
                                    showTime: false,
                                    showDate: true,
                                    details.date.toString(),
                                  ),
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
