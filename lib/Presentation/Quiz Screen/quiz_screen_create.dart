import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'package:st_teacher_app/Presentation/Homework/controller/teacher_class_controller.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/controller/quiz_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Quiz Screen/quiz_history.dart';
import 'package:get/get.dart';

class AnswerModel {
  String text;
  bool isCorrect;

  AnswerModel({this.text = '', this.isCorrect = false});

  Map<String, dynamic> toJson() {
    return {"text": text, "isCorrect": isCorrect};
  }
}

class QuestionModel {
  String question;
  List<AnswerModel> answers;

  QuestionModel({this.question = '', List<AnswerModel>? answers})
    : answers = answers ?? List.generate(4, (_) => AnswerModel());

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "answers": answers.map((a) => a.toJson()).toList(),
    };
  }
}

class QuizScreenCreate extends StatefulWidget {
  const QuizScreenCreate({super.key});

  @override
  State<QuizScreenCreate> createState() => _QuizScreenCreateState();
}

class _QuizScreenCreateState extends State<QuizScreenCreate> {
  final TeacherClassController teacherClassController = Get.put(
    TeacherClassController(),
  );
  final QuizController controller = Get.put(QuizController());
  final List<QuestionModel> questionList = [];

  final List<Map<String, String>> classData = const [
    {'grade': '8', 'section': 'A'},
    {'grade': '8', 'section': 'B'},
    {'grade': '8', 'section': 'C'},
    {'grade': '9', 'section': 'A'},
    {'grade': '9', 'section': 'C'},
  ];

  final List<Map<String, dynamic>> tabs = const [
    {"label": "Social Science"},
    {"label": "English"},
  ];

  // --- UI State ---
  int selectedIndex = 0;
  int subjectIndex = 0;
  int? selectedClassId;

  bool showClearIcon = false;
  final TextEditingController headingController = TextEditingController();
  final TextEditingController timeLimitController = TextEditingController();

  final Set<int> _invalidQuestions = {};
  final Map<int, Set<int>> _invalidAnswers = {};
  bool _headingInvalid = false;
  bool _timeLimitInvalid = false;
  bool _classInvalid = false;
  bool _subjectInvalid = false;
  String? selectedSubject;
  int? selectedSubjectId;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (teacherClassController.subjectList.isNotEmpty) {
        subjectIndex = 0;
        selectedSubject = teacherClassController.subjectList[0].name;
        selectedSubjectId = teacherClassController.subjectList[0].id;
        selectedClassId = teacherClassController.classList[0].id;
      }

      setState(() {});
    });
    headingController.addListener(() {
      setState(() => showClearIcon = headingController.text.isNotEmpty);
    });

    if (questionList.isEmpty) {
      questionList.add(QuestionModel());
    }
  }

  @override
  void dispose() {
    headingController.dispose();
    timeLimitController.dispose();
    super.dispose();
  }

  String getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) return 'th';
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void _addMoreQuestion() {
    setState(() {
      questionList.add(QuestionModel());
    });
  }

  // Simple styled input shell (for multi-line fields) to mimic your look
  Widget _inputShell({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColor.lightWhite,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // -------------------- VALIDATION & PAYLOAD --------------------
  Map<String, dynamic>? _validateAndBuildPayload() {
    bool hasError = false;

    setState(() {
      _subjectInvalid = false;
      _headingInvalid = false;
      _timeLimitInvalid = false;
      _invalidQuestions.clear();
      _invalidAnswers.clear();
    });

    // Subject validation
    if (subjectIndex == null) {
      _subjectInvalid = true;
      hasError = true;
    }

    // Heading validation
    if (headingController.text.trim().isEmpty) {
      _headingInvalid = true;
      hasError = true;
    }

    // Time limit validation
    if (timeLimitController.text.trim().isEmpty ||
        int.tryParse(timeLimitController.text) == null) {
      _timeLimitInvalid = true;
      hasError = true;
    }

    // Questions & Answers validation
    for (int qIndex = 0; qIndex < questionList.length; qIndex++) {
      final q = questionList[qIndex];

      if (q.question.trim().isEmpty) {
        _invalidQuestions.add(qIndex);
        hasError = true;
      }

      for (int aIndex = 0; aIndex < q.answers.length; aIndex++) {
        if (q.answers[aIndex].text.trim().isEmpty) {
          _invalidAnswers.putIfAbsent(qIndex, () => {}).add(aIndex);
          hasError = true;
        }
      }

      // at least 1 correct answer
      if (!q.answers.any((a) => a.isCorrect)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Question ${qIndex + 1}: mark at least one correct answer",
            ),
          ),
        );
        hasError = true;
      }
    }

    if (hasError) {
      setState(() {}); // update UI with errors
      return null;
    }

    // ✅ Build payload
    return {
      "classId": selectedClassId,
      "subjectId": selectedSubjectId,
      "heading": headingController.text.trim(),
      "timeLimit": int.parse(timeLimitController.text),
      "publish": true,
      "questions":
          questionList.map((q) {
            return {
              "text": q.question,
              "options":
                  q.answers.map((a) {
                    return {"text": a.text, "isCorrect": a.isCorrect};
                  }).toList(),
            };
          }).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          final classes = teacherClassController.classList;
          final subjects = teacherClassController.subjectList;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
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
                              builder: (_) => const QuizHistory(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              'History',
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
                  Center(
                    child: Text(
                      'Create Quiz',
                      style: GoogleFont.ibmPlexSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Class
                          Text(
                            'Class',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            height: 100,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColor.white.withOpacity(0.3),
                                          AppColor.lowLightgray,
                                          AppColor.lowLightgray,
                                          AppColor.lowLightgray,
                                          AppColor.lowLightgray,
                                          AppColor.lowLightgray,
                                          AppColor.white.withOpacity(0.3),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -20,
                                  bottom: -20,
                                  left: 0,
                                  right: 0,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: classes.length,
                                    itemBuilder: (context, index) {
                                      final item = classes[index];
                                      final isSelected = index == selectedIndex;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                            selectedClassId = item.id;
                                            teacherClassController
                                                .selectedClass
                                                .value = item;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 120,
                                          ),
                                          curve: Curves.easeInOut,
                                          width: 90,
                                          height: isSelected ? 120 : 80,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 0,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? AppColor.white
                                                    : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            border:
                                                isSelected
                                                    ? Border.all(
                                                      color: AppColor.blueG1,
                                                      width: 1.5,
                                                    )
                                                    : null,
                                            boxShadow:
                                                isSelected
                                                    ? [
                                                      BoxShadow(
                                                        color: AppColor.white
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: const Offset(
                                                          0,
                                                          4,
                                                        ),
                                                      ),
                                                    ]
                                                    : [],
                                          ),
                                          child:
                                              isSelected
                                                  ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ShaderMask(
                                                            shaderCallback:
                                                                (
                                                                  bounds,
                                                                ) => const LinearGradient(
                                                                  colors: [
                                                                    AppColor
                                                                        .blueG1,
                                                                    AppColor
                                                                        .blue,
                                                                  ],
                                                                  begin:
                                                                      Alignment
                                                                          .topLeft,
                                                                  end:
                                                                      Alignment
                                                                          .bottomRight,
                                                                ).createShader(
                                                                  Rect.fromLTWH(
                                                                    0,
                                                                    0,
                                                                    bounds
                                                                        .width,
                                                                    bounds
                                                                        .height,
                                                                  ),
                                                                ),
                                                            blendMode:
                                                                BlendMode.srcIn,
                                                            child: Text(
                                                              item.name,
                                                              style: GoogleFont.ibmPlexSans(
                                                                fontSize: 28,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 8.0,
                                                                ),
                                                            child: ShaderMask(
                                                              shaderCallback:
                                                                  (
                                                                    bounds,
                                                                  ) => const LinearGradient(
                                                                    colors: [
                                                                      AppColor
                                                                          .blueG1,
                                                                      AppColor
                                                                          .blue,
                                                                    ],
                                                                    begin:
                                                                        Alignment
                                                                            .topLeft,
                                                                    end:
                                                                        Alignment
                                                                            .bottomRight,
                                                                  ).createShader(
                                                                    Rect.fromLTWH(
                                                                      0,
                                                                      0,
                                                                      bounds
                                                                          .width,
                                                                      bounds
                                                                          .height,
                                                                    ),
                                                                  ),
                                                              blendMode:
                                                                  BlendMode
                                                                      .srcIn,
                                                              child: Text(
                                                                'th',
                                                                style: GoogleFont.ibmPlexSans(
                                                                  fontSize: 14,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        height: 55,
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                                colors: [
                                                                  AppColor
                                                                      .blueG1,
                                                                  AppColor.blue,
                                                                ],
                                                                begin:
                                                                    Alignment
                                                                        .topLeft,
                                                                end:
                                                                    Alignment
                                                                        .topRight,
                                                              ),
                                                          borderRadius:
                                                              const BorderRadius.vertical(
                                                                bottom:
                                                                    Radius.circular(
                                                                      22,
                                                                    ),
                                                              ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          item.section,
                                                          style:
                                                              GoogleFont.ibmPlexSans(
                                                                fontSize: 20,
                                                                color:
                                                                    AppColor
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : Center(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 20,
                                                                vertical: 3,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color:
                                                                AppColor.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            item.name,
                                                            style:
                                                                GoogleFont.ibmPlexSans(
                                                                  fontSize: 14,
                                                                  color:
                                                                      AppColor
                                                                          .gray,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          item.section,
                                                          style: GoogleFont.ibmPlexSans(
                                                            fontSize: 20,
                                                            color:
                                                                AppColor
                                                                    .lightgray,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Subject tabs
                          Text(
                            'Subject',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            children: List.generate(subjects.length, (index) {
                              final sub = subjects[index];
                              final isSelected = subjectIndex == index;
                              return GestureDetector(
                                onTap:
                                    () => setState(() {
                                      subjectIndex = index;
                                      selectedSubjectId = sub.id;
                                    }),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? AppColor.blue
                                              : AppColor.borderGary,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected) ...[
                                        Icon(
                                          Icons.check,
                                          size: 16,
                                          color: AppColor.blue,
                                        ),
                                        SizedBox(width: 6),
                                      ],
                                      Text(
                                        sub.name,
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              isSelected
                                                  ? AppColor.blue
                                                  : AppColor.gray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),

                          /*   Container(
                            decoration: BoxDecoration(
                              border:
                                  _subjectInvalid
                                      ? Border.all(
                                        color: Colors.red,
                                        width: 1.2,
                                      )
                                      : null,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: List.generate(tabs.length, (index) {
                                final isSelected = subjectIndex == index;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap:
                                        () => setState(() {
                                          subjectIndex = index;
                                          _subjectInvalid = false;
                                        }),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSelected ? 25 : 35,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? AppColor.blue
                                                  : AppColor.borderGary,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          if (isSelected)
                                            Image.asset(
                                              AppImages.tick,
                                              height: 15,
                                              color: AppColor.blue,
                                            ),
                                          if (isSelected)
                                            const SizedBox(width: 10),
                                          Text(
                                            " ${tabs[index]['label']}",
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 12,
                                              color:
                                                  isSelected
                                                      ? AppColor.blue
                                                      : AppColor.gray,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),*/
                          const SizedBox(height: 25),

                          // Heading
                          Text(
                            'Heading',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    _headingInvalid
                                        ? Colors.red
                                        : Colors.transparent,
                                width: 1.2,
                              ),
                            ),
                            child: CommonContainer.fillingContainer(
                              onDetailsTap: () {
                                headingController.clear();
                                setState(() => showClearIcon = false);
                              },
                              imagePath: showClearIcon ? AppImages.close : null,
                              imageColor: AppColor.gray,
                              text: '',
                              controller: headingController,
                              verticalDivider: false,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Time Limit
                          Text(
                            'Time Limit',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    _timeLimitInvalid
                                        ? Colors.red
                                        : Colors.transparent,
                                width: 1.2,
                              ),
                            ),
                            child: CommonContainer.fillingContainer(
                              keyboardType:
                                  TextInputType
                                      .number, // ✅ numbers only keyboard
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              imagePath: AppImages.clock,
                              imageColor: AppColor.lightgray,
                              text: '',
                              controller: timeLimitController,
                              verticalDivider: false,
                            ),
                          ),

                          const SizedBox(height: 25),

                          Column(
                            children: List.generate(questionList.length, (
                              qIndex,
                            ) {
                              final q = questionList[qIndex];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Q${qIndex + 1}",
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.borderGary,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Question field
                                    TextFormField(
                                      initialValue: q.question,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: "Enter question",
                                        filled: true,
                                        fillColor: AppColor.lightWhite,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                _invalidQuestions.contains(
                                                      qIndex,
                                                    )
                                                    ? Colors.red
                                                    : Colors.transparent,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColor.blue,
                                          ),
                                        ),
                                      ),
                                      onChanged: (val) {
                                        q.question = val;
                                        if (val.isNotEmpty) {
                                          setState(
                                            () => _invalidQuestions.remove(
                                              qIndex,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Answer',
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    Column(
                                      children: List.generate(q.answers.length, (
                                        aIndex,
                                      ) {
                                        final a = q.answers[aIndex];
                                        final isInvalid =
                                            _invalidAnswers[qIndex]?.contains(
                                              aIndex,
                                            ) ??
                                            false;

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColor.lightWhite,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(
                                                color:
                                                    isInvalid
                                                        ? Colors.red
                                                        : Colors.transparent,
                                                width: 1.2,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    initialValue: a.text,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'List ${aIndex + 1}',
                                                      hintStyle:
                                                          GoogleFont.ibmPlexSans(
                                                            fontSize: 14,
                                                            color:
                                                                AppColor.gray,
                                                          ),
                                                      border: InputBorder.none,
                                                    ),
                                                    onChanged: (val) {
                                                      a.text = val;

                                                      // ✅ Mark first option as correct automatically
                                                      a.isCorrect =
                                                          (aIndex == 0);
                                                    },
                                                  ),
                                                ),

                                                // Instead of checkbox, just show label for clarity
                                                if (aIndex == 0)
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 8,
                                                    ),
                                                    child: Text(
                                                      "(Answer)",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 25),

                          // Add Question
                          GestureDetector(
                            onTap: _addMoreQuestion,
                            child: DottedBorder(
                              color: AppColor.blue,
                              strokeWidth: 1.5,
                              dashPattern: const [8, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Add Question',
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColor.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Publish
                          AppButton.button(
                            onTap: () async {
                              HapticFeedback.heavyImpact();

                              final payload = _validateAndBuildPayload();
                              if (payload == null) return;

                              // TODO: send `payload` to backend
                              AppLogger.log.i(payload);
                              await controller.quizCreate(payload);

                              // Navigate after success (for now)
                              // if (mounted) {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (_) => const QuizHistory(),
                              //     ),
                              //   );
                              // }
                            },
                            width: 145,
                            height: 60,
                            text: 'Publish',
                            image: AppImages.buttonArrow,
                          ),
                        ],
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
