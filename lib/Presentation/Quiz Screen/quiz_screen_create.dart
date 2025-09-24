/*import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Quiz Screen/quiz_history.dart';

class QuestionModel {
  String question;
  List<String> answers;
  QuestionModel({this.question = '', List<String>? answers})
    : answers = answers ?? List.generate(4, (_) => '');
}

class QuizScreenCreate extends StatefulWidget {
  const QuizScreenCreate({super.key});

  @override
  State<QuizScreenCreate> createState() => _QuizScreenCreateState();
}

class _QuizScreenCreateState extends State<QuizScreenCreate> {
  // --- Data ---
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

  bool showClearIcon = false;
  final TextEditingController headingController = TextEditingController();
  final TextEditingController timeLimitController = TextEditingController();

  // ===== Validation state =====
  final Set<int> _invalidQuestions = {};
  final Map<int, Set<int>> _invalidAnswers = {}; // qIndex -> set of aIndex
  bool _headingInvalid = false;
  bool _timeLimitInvalid = false;
  bool _classInvalid = false;
  bool _subjectInvalid = false;

  @override
  void initState() {
    super.initState();

    // Show/hide clear icon for heading field
    headingController.addListener(() {
      setState(() => showClearIcon = headingController.text.isNotEmpty);
    });

    // Ensure at least one question exists
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

  /// Returns payload if valid, else null
  Map<String, dynamic>? _validateAndBuildPayload() {
    _invalidQuestions.clear();
    _invalidAnswers.clear();
    _headingInvalid = false;
    _timeLimitInvalid = false;
    _classInvalid = false;
    _subjectInvalid = false;

    // Class
    if (selectedIndex < 0 || selectedIndex >= classData.length) {
      _classInvalid = true;
      setState(() {});
      _showError('Please select a class');
      return null;
    }
    final classSel = classData[selectedIndex]; // {'grade': '8', 'section': 'A'}

    // Subject
    if (subjectIndex < 0 || subjectIndex >= tabs.length) {
      _subjectInvalid = true;
      setState(() {});
      _showError('Please select a subject');
      return null;
    }
    final subjectSel = tabs[subjectIndex]['label']?.toString().trim() ?? '';

    // Heading (title)
    final title = headingController.text.trim();
    if (title.isEmpty) {
      _headingInvalid = true;
      setState(() {});
      _showError('Heading is required');
      return null;
    }

    // Time limit (mins) — restrict to digits only and 1..180
    final tl = int.tryParse(timeLimitController.text.trim());
    if (tl == null || tl <= 0 || tl > 180) {
      _timeLimitInvalid = true;
      setState(() {});
      _showError('Time Limit must be a number between 1 and 180');
      return null;
    }

    // At least one question
    if (questionList.isEmpty) {
      _showError('Add at least one question');
      return null;
    }

    // Questions + answers
    for (int q = 0; q < questionList.length; q++) {
      final qModel = questionList[q];
      final qText = qModel.question.trim();

      if (qText.isEmpty) {
        _invalidQuestions.add(q);
        setState(() {});
        _showError('Question ${q + 1} cannot be empty');
        return null;
      }

      final answers = qModel.answers.map((e) => e.trim()).toList();
      if (answers.length < 2) {
        _invalidQuestions.add(q);
        setState(() {});
        _showError('Question ${q + 1} must have at least 2 answers');
        return null;
      }

      int nonEmpty = 0;
      for (int a = 0; a < answers.length; a++) {
        if (answers[a].isEmpty) {
          _invalidAnswers.putIfAbsent(q, () => {}).add(a);
        } else {
          nonEmpty++;
        }
      }
      if (nonEmpty < 2) {
        _invalidQuestions.add(q);
        setState(() {});
        _showError('Question ${q + 1} must have at least 2 non-empty answers');
        return null;
      }
    }

    // ✅ Build payload
    final payload = {
      'class': {'grade': classSel['grade'], 'section': classSel['section']},
      'subject': subjectSel,
      'title': title,
      'timeLimit': tl,
      'questions': List.generate(questionList.length, (q) {
        final qModel = questionList[q];
        return {
          'text': qModel.question.trim(),
          'options': qModel.answers.map((t) => {'text': t.trim()}).toList(),
        };
      }),
    };

    setState(() {}); // refresh borders if any were marked earlier
    return payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      border: Border.all(color: AppColor.lightgray, width: 0.3),
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

                // Card
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
                                child: Container(
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    border:
                                        _classInvalid
                                            ? Border.all(
                                              color: Colors.red,
                                              width: 1.2,
                                            )
                                            : null,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: classData.length,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = classData[index];
                                      final grade = item['grade']!;
                                      final section = item['section']!;
                                      final isSelected = index == selectedIndex;

                                      return GestureDetector(
                                        onTap:
                                            () => setState(() {
                                              selectedIndex = index;
                                              _classInvalid = false;
                                            }),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 40,
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
                                                              grade,
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
                                                        decoration: const BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              AppColor.blueG1,
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
                                                              BorderRadius.vertical(
                                                                bottom:
                                                                    Radius.circular(
                                                                      22,
                                                                    ),
                                                              ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          section,
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
                                                            grade,
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
                                                          section,
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

                        Container(
                          decoration: BoxDecoration(
                            border:
                                _subjectInvalid
                                    ? Border.all(color: Colors.red, width: 1.2)
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
                        ),

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
                                TextInputType.number, // ✅ numbers only keyboard
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

                        // QUESTIONS LIST (no ListView; safe in SingleChildScrollView)
                        Column(
                          children: List.generate(questionList.length, (
                            qIndex,
                          ) {
                            final model = questionList[qIndex];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Q number with ordinal
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFont.ibmPlexSans(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.borderGary,
                                      ),
                                      children: [
                                        TextSpan(text: '${qIndex + 1}'),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(2, -7),
                                            child: Text(
                                              getOrdinalSuffix(qIndex + 1),
                                              textScaleFactor: 0.6,
                                              style: GoogleFont.ibmPlexSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: AppColor.borderGary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Question field (with invalid border)
                                  Text(
                                    'Question',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color:
                                            _invalidQuestions.contains(qIndex)
                                                ? Colors.red
                                                : Colors.transparent,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: _inputShell(
                                      child: TextFormField(
                                        initialValue: model.question,
                                        maxLines: 5,
                                        decoration: const InputDecoration(
                                          hintText: 'Type your question',
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (val) {
                                          model.question = val;
                                          if (val.trim().isNotEmpty &&
                                              _invalidQuestions.contains(
                                                qIndex,
                                              )) {
                                            setState(
                                              () => _invalidQuestions.remove(
                                                qIndex,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Answers title
                                  Text(
                                    'Answer',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Four answers
                                  Column(
                                    children: List.generate(model.answers.length, (
                                      aIndex,
                                    ) {
                                      final isInvalid =
                                          (_invalidAnswers[qIndex]?.contains(
                                            aIndex,
                                          )) ??
                                          false;

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 14,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.lightWhite,
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
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
                                              // Text field
                                              Expanded(
                                                child: TextFormField(
                                                  initialValue:
                                                      model.answers[aIndex],
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'List ${aIndex + 1}',
                                                    hintStyle:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 14,
                                                          color: AppColor.gray,
                                                        ),
                                                    border: InputBorder.none,
                                                  ),
                                                  onChanged: (value) {
                                                    model.answers[aIndex] =
                                                        value;
                                                    if (isInvalid &&
                                                        value
                                                            .trim()
                                                            .isNotEmpty) {
                                                      setState(() {
                                                        _invalidAnswers[qIndex]
                                                            ?.remove(aIndex);
                                                        if ((_invalidAnswers[qIndex]
                                                                ?.isEmpty ??
                                                            true)) {
                                                          _invalidAnswers
                                                              .remove(qIndex);
                                                        }
                                                      });
                                                    }
                                                  },
                                                  inputFormatters: const [
                                                    // allow any text; remove if not required
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),

                                  const Divider(),
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
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
                            if (payload == null) return; // stop on first error

                            // TODO: send `payload` to backend
                            // await quizController.createQuiz(payload);

                            // Navigate after success (for now)
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const QuizHistory(),
                                ),
                              );
                            }
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
        ),
      ),
    );
  }
}*/

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'package:st_teacher_app/Presentation/Homework/controller/teacher_class_controller.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/controller/quiz_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Quiz Screen/quiz_history.dart';

class AnswerModel {
  String text;
  bool isCorrect;

  AnswerModel({this.text = '', this.isCorrect = false});

  Map<String, dynamic> toJson() => {"text": text, "isCorrect": isCorrect};
}

// ===== Models =====
class AnswerItem {
  String text;
  bool isCorrect;
  AnswerItem({this.text = '', this.isCorrect = false});
}

class QuestionItem {
  String question;
  List<AnswerItem> answers;
  QuestionItem({required this.question, required this.answers});

  factory QuestionItem.blank({int options = 4}) {
    return QuestionItem(
      question: '',
      answers: List.generate(
        options,
        (i) =>
            AnswerItem(text: '', isCorrect: i == 0), // first is correct by rule
      ),
    );
  }
}

class QuestionModel {
  String question;
  List<AnswerModel> answers;

  QuestionModel({this.question = '', List<AnswerModel>? answers})
    : answers = answers ?? List.generate(4, (_) => AnswerModel());
  Map<String, dynamic> toJson() => {
    "question": question,
    "answers": answers.map((a) => a.toJson()).toList(),
  };
}

class QuizScreenCreate extends StatefulWidget {
  final String? className;
  final String? section;
  const QuizScreenCreate({super.key, this.className, this.section});

  @override
  State<QuizScreenCreate> createState() => _QuizScreenCreateState();
}

class _QuizScreenCreateState extends State<QuizScreenCreate> {
  final TeacherClassController teacherClassController = Get.put(
    TeacherClassController(),
  );
  final QuizController controller = Get.put(QuizController());

  // ===== State (inside your State class) =====

  // show only 1 question initially
  final List<QuestionItem> questionList = [QuestionItem.blank()];

  // validation helpers you already reference
  final Set<int> _invalidQuestions = <int>{};
  final Map<int, Set<int>> _invalidAnswers = <int, Set<int>>{};

  // --- UI State ---
  int selectedIndex = 0; // class index in horizontal list
  int subjectIndex = 0; // index in subject chips
  int? selectedClassId;
  int? selectedSubjectId;
  String? selectedSubject;
  bool showClearIcon = false;
  final TextEditingController headingController = TextEditingController();
  final TextEditingController timeLimitController = TextEditingController();
  final List<TextEditingController> descriptionControllers = [];
  // Validation state
  bool _headingInvalid = false;
  bool _timeLimitInvalid = false;
  bool _classInvalid = false;
  bool _subjectInvalid = false;

  // --- Class scroller centering ---
  final ScrollController _classScroll = ScrollController();
  static const double _classItemWidth = 90; // must match your item width
  static const double _classGap =
      0; // horizontal gap between items (update if you add spacing)

  void _centerSelectedClass({bool animate = true}) {
    if (!_classScroll.hasClients) return;

    final viewport = _classScroll.position.viewportDimension;
    final itemExtent = _classItemWidth + _classGap;
    final targetCenter = selectedIndex * itemExtent + (_classItemWidth / 2.0);
    final targetOffset = targetCenter - (viewport / 2.0);

    final maxExtent = _classScroll.position.maxScrollExtent;
    final offset = targetOffset.clamp(0.0, maxExtent);

    if (animate) {
      _classScroll.animateTo(
        offset,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _classScroll.jumpTo(offset);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ... your existing defaultClass / subject setup ...

      setState(() {}); // you already had this
      // Center the default/initial selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerSelectedClass(animate: false);
      });
    });

    // Always show at least 1 description field
    descriptionControllers.add(TextEditingController());

    headingController.addListener(() {
      setState(() => showClearIcon = headingController.text.isNotEmpty);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (teacherClassController.classList.isNotEmpty) {
        final defaultClass = teacherClassController.classList.firstWhere(
          (c) =>
              c.name == (widget.className ?? c.name) &&
              c.section == (widget.section ?? c.section),
          orElse: () => teacherClassController.classList.first,
        );
        teacherClassController.selectedClass.value = defaultClass;
        selectedIndex = teacherClassController.classList.indexOf(defaultClass);
        selectedClassId = defaultClass.id;
      }

      if (teacherClassController.subjectList.isNotEmpty) {
        subjectIndex = 0;
        selectedSubject = teacherClassController.subjectList[0].name;
        selectedSubjectId = teacherClassController.subjectList[0].id;
      }

      setState(() {});
    });

    headingController.addListener(() {
      setState(() {
        showClearIcon = headingController.text.isNotEmpty;
        if (_headingInvalid && headingController.text.trim().isNotEmpty) {
          _headingInvalid = false;
        }
      });
    });

    // Time limit listener: clear error when valid (>0) number
    timeLimitController.addListener(() {
      final v = timeLimitController.text.trim();
      final n = int.tryParse(v);
      setState(() {
        if (_timeLimitInvalid && n != null && n > 0) {
          _timeLimitInvalid = false;
        }
      });
    });

    // Always have at least one question to start
    if (questionList.isEmpty) questionList.add(QuestionModel() as QuestionItem);
  }

  @override
  void dispose() {
    headingController.dispose();
    timeLimitController.dispose();
    super.dispose();
  }

  void _addMoreQuestion() {
    setState(() {
      questionList.add(QuestionItem.blank());
    });
  }

  void _removeQuestion(int qIndex) {
    if (qIndex == 0) return; // keep first question always visible
    setState(() {
      questionList.removeAt(qIndex);

      // Clean up validation markers for removed index (simple reset)
      _invalidQuestions.removeWhere((i) => i >= qIndex);
      _invalidAnswers.removeWhere((i, _) => i >= qIndex);
    });
  }

  String _formatMinutes(int m) => m > 0 ? '$m min' : '';
  Duration _timeLimit = const Duration(minutes: 0);
  int _minutes = 0;
  // Format like "1h 30m" or "25 min"
  String _formatDuration(Duration d) {
    final m = d.inMinutes % 60;
    if (m > 0) return ' ${m}m';
    return '${m} min';
  }

  int _digitsOrZero(String s) {
    final m = RegExp(r'\d+').firstMatch(s);
    return m == null ? 0 : int.parse(m.group(0)!);
  }

  int _extractMinutes(String input) {
    final m = RegExp(r'(\d+)').firstMatch(input);
    if (m == null) return 0;
    return int.parse(m.group(1)!);
  }

  Future<void> _pickMinutes(BuildContext context) async {
    const minValue = 1;
    const maxValue = 300;

    int temp = _minutes;
    if (temp < minValue) temp = minValue;
    if (temp > maxValue) temp = maxValue;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Minutes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  height: 180,
                  child: CupertinoPicker(
                    itemExtent: 36,
                    scrollController: FixedExtentScrollController(
                      initialItem: temp - minValue,
                    ),
                    onSelectedItemChanged: (i) => temp = i + minValue,
                    children: List.generate(maxValue - minValue + 1, (i) {
                      final v = i + minValue;
                      return Center(child: Text('$v min'));
                    }),
                  ),
                ),

                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: GoogleFont.ibmPlexSans(
                            color: AppColor.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _minutes = temp; // save picked minutes
                            timeLimitController.text =
                                '$_minutes min'; // show in the field
                            _timeLimitInvalid =
                                _minutes <= 0 ? true : false; // clear error
                          });
                          Navigator.pop(ctx); // close the sheet
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Text(
                                "Done",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /*  ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _minutes = temp;                         // save picked minutes
                            timeLimitController.text = '$_minutes min'; // show in the field
                            _timeLimitInvalid = _minutes <= 0 ? true : false; // clear error
                          });
                          Navigator.pop(ctx); // close the sheet
                        },
                        child: Text('Done'),
                      ),*/
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // -------------------- VALIDATION & PAYLOAD --------------------
  Map<String, dynamic>? _validateAndBuildPayload() {
    bool hasError = false;

    // reset flags
    setState(() {
      _classInvalid = false;
      _subjectInvalid = false;
      _headingInvalid = false;
      _timeLimitInvalid = false;
      _invalidQuestions.clear();
      _invalidAnswers.clear();
    });

    // Class required
    if (selectedClassId == null) {
      _classInvalid = true;
      hasError = true;
    }

    // Subject required
    if (selectedSubjectId == null) {
      _subjectInvalid = true;
      hasError = true;
    }

    // Heading required
    if (headingController.text.trim().isEmpty) {
      _headingInvalid = true;
      hasError = true;
    }

    // ----- Time limit (> 0). Prefer picker value; fallback to digits in text -----
    final typed = timeLimitController.text.trim();
    int timeNum = _minutes > 0 ? _minutes : _extractMinutes(typed);
    if (timeNum <= 0) {
      _timeLimitInvalid = true;
      hasError = true;
    }

    // Questions & Answers required
    for (int qIndex = 0; qIndex < questionList.length; qIndex++) {
      final q = questionList[qIndex];

      if (q.question.trim().isEmpty) {
        _invalidQuestions.add(qIndex);
        hasError = true;
      }

      for (int aIndex = 0; aIndex < q.answers.length; aIndex++) {
        if (q.answers[aIndex].text.trim().isEmpty) {
          (_invalidAnswers[qIndex] ??= <int>{}).add(aIndex);
          hasError = true;
        }
      }

      // At least 1 correct answer
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

    return {
      "classId": selectedClassId,
      "subjectId": selectedSubjectId,
      "heading": headingController.text.trim(),
      "timeLimit": timeNum, // <- clean numeric minutes
      "publish": true,
      "questions":
          questionList.map((q) {
            return {
              "text": q.question.trim(),
              "options":
                  q.answers
                      .map(
                        (a) => {
                          "text": a.text.trim(),
                          "isCorrect": a.isCorrect,
                        },
                      )
                      .toList(),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ------------------ Class ------------------
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 20,
                          ),
                          child: Text(
                            'Class',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
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
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final count = classes.length;
                                    // total width of all cards + gaps
                                    final totalW =
                                        count * _classItemWidth +
                                        (count - 1) * _classGap;
                                    // if content is narrower than viewport, add symmetric side padding to center the row
                                    final sidePad =
                                        totalW < constraints.maxWidth
                                            ? (constraints.maxWidth - totalW) /
                                                2.0
                                            : 0.0;

                                    return ListView.builder(
                                      controller: _classScroll,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: classes.length,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: sidePad,
                                      ), // <-- key change
                                      itemBuilder: (context, index) {
                                        final item = classes[index];
                                        final isSelected =
                                            index == selectedIndex;

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                              selectedClassId = item.id;
                                              teacherClassController
                                                  .selectedClass
                                                  .value = item;
                                            });
                                            // center after layout updates
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                                  _centerSelectedClass();
                                                });
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 120,
                                            ),
                                            curve: Curves.easeInOut,
                                            width:
                                                _classItemWidth, // <-- keep in sync
                                            height: isSelected ? 120 : 80,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal:
                                                  _classGap /
                                                  2, // <-- if you add spacing, bump _classGap
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? AppColor.white
                                                      : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(24),
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
                                            // ===== your existing inner UI (unchanged) =====
                                            child:
                                                isSelected
                                                    ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
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
                                                                  BlendMode
                                                                      .srcIn,
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
                                                                    fontSize:
                                                                        14,
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
                                                          width:
                                                              double.infinity,
                                                          decoration: const BoxDecoration(
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                AppColor.blueG1,
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
                                                                BorderRadius.vertical(
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
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 3,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color:
                                                                      AppColor
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        20,
                                                                      ),
                                                                ),
                                                            child: Text(
                                                              item.name,
                                                              style: GoogleFont.ibmPlexSans(
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
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            // ===== end unchanged UI =====
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),

                                /*ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: classes.length,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = classes[index];
                                      final isSelected =
                                          index == selectedIndex;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                            selectedClassId = item.id;
                                            teacherClassController.selectedClass.value = item;
                                          });
                                          // Center after the frame updates sizes/positions
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            _centerSelectedClass();
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
                                            borderRadius:
                                                BorderRadius.circular(24),
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
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
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
                                                                BlendMode
                                                                    .srcIn,
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
                                                                  fontSize:
                                                                      14,
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
                                                        width:
                                                            double.infinity,
                                                        decoration: BoxDecoration(
                                                          gradient: const LinearGradient(
                                                            colors: [
                                                              AppColor.blueG1,
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
                                                                horizontal:
                                                                    20,
                                                                vertical: 3,
                                                              ),
                                                          decoration:
                                                              BoxDecoration(
                                                                color:
                                                                    AppColor
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      20,
                                                                    ),
                                                              ),
                                                          child: Text(
                                                            item.name,
                                                            style: GoogleFont.ibmPlexSans(
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
                                                                FontWeight
                                                                    .bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                        ),
                                      );
                                    },
                                  ),*/
                              ),
                            ],
                          ),
                        ),
                        if (_classInvalid)
                          const Padding(
                            padding: EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Class is required',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),

                        const SizedBox(height: 40),

                        // ------------------ Subject ------------------
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 20,
                          ),
                          child: Text(
                            'Subject',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Wrap(
                            spacing: 10,
                            children: List.generate(subjects.length, (index) {
                              final sub = subjects[index];
                              final isSelected = subjectIndex == index;
                              return GestureDetector(
                                onTap:
                                    () => setState(() {
                                      subjectIndex = index;
                                      selectedSubjectId = sub.id;
                                      _subjectInvalid = false;
                                    }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
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
                                        const SizedBox(width: 6),
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
                        ),
                        if (_subjectInvalid)
                          const Padding(
                            padding: EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Subject is required',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),

                        const SizedBox(height: 25),

                        // ------------------ Heading ------------------
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    setState(() {
                                      showClearIcon = false;
                                      _headingInvalid =
                                          true; // empty -> invalid
                                    });
                                  },
                                  // If your component supports onChanged, this helps clear red faster:
                                  onChanged: (v) {
                                    setState(() {
                                      if (_headingInvalid &&
                                          v.trim().isNotEmpty) {
                                        _headingInvalid = false;
                                      }
                                      showClearIcon = v.isNotEmpty;
                                    });
                                  },
                                  imagePath:
                                      showClearIcon ? AppImages.close : null,
                                  imageColor: AppColor.gray,
                                  text: '',
                                  controller: headingController,
                                  verticalDivider: false,
                                ),
                              ),
                              if (_headingInvalid)
                                const Padding(
                                  padding: EdgeInsets.only(top: 6, left: 4),
                                  child: Text(
                                    'Heading is required',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 25),

                              // ------------------ Time Limit ------------------
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
                                child: GestureDetector(
                                  onTap: () => _pickMinutes(context),
                                  child: AbsorbPointer(
                                    // Prevents keyboard; value only set via picker
                                    child: CommonContainer.fillingContainer(
                                      imagePath: AppImages.clock,
                                      imageColor: AppColor.lightgray,
                                      text: '',
                                      controller: timeLimitController,
                                      verticalDivider: false,
                                      onChanged: (v) {
                                        setState(() {
                                          _minutes = _digitsOrZero(v);
                                          _timeLimitInvalid = _minutes <= 0;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              if (_timeLimitInvalid)
                                const Padding(
                                  padding: EdgeInsets.only(top: 6, left: 4),
                                  child: Text(
                                    'Time Limit is required',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 25),

                              // ------------------ Questions & Answers ------------------
                              Column(
                                children: List.generate(questionList.length, (
                                  qIndex,
                                ) {
                                  final q = questionList[qIndex];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ===== Small UI tweak (optional): add a remove icon for qIndex > 0 =====
                                        // Right under your "Q${qIndex + 1}" Text, show a delete icon only for questions after the first.
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Q${qIndex + 1}",
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.borderGary,
                                              ),
                                            ),
                                            if (qIndex > 0)
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                ),
                                                onPressed:
                                                    () =>
                                                        _removeQuestion(qIndex),
                                                tooltip: 'Remove Question',
                                              ),
                                          ],
                                        ),

                                        SizedBox(height: 10),

                                        // Question field
                                        TextFormField(
                                          initialValue: q.question,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            hintText: "Enter question",
                                            filled: true,
                                            fillColor: AppColor.lightWhite,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide(
                                                color: AppColor.blue,
                                              ),
                                            ),
                                          ),
                                          onChanged: (val) {
                                            q.question = val;
                                            if (val.trim().isNotEmpty) {
                                              setState(
                                                () => _invalidQuestions.remove(
                                                  qIndex,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        if (_invalidQuestions.contains(qIndex))
                                          const Padding(
                                            padding: EdgeInsets.only(
                                              top: 6,
                                              left: 4,
                                            ),
                                            child: Text(
                                              'Question is required',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
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
                                                _invalidAnswers[qIndex]
                                                    ?.contains(aIndex) ??
                                                false;

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColor.lightWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            18,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            isInvalid
                                                                ? Colors.red
                                                                : Colors
                                                                    .transparent,
                                                        width: 1.2,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextFormField(
                                                            initialValue:
                                                                a.text,
                                                            decoration: InputDecoration(
                                                              hintText:
                                                                  'List ${aIndex + 1}',
                                                              hintStyle:
                                                                  GoogleFont.ibmPlexSans(
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        AppColor
                                                                            .gray,
                                                                  ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            onChanged: (val) {
                                                              a.text = val;

                                                              // Your rule: first option auto-correct
                                                              a.isCorrect =
                                                                  (aIndex == 0);

                                                              if (val
                                                                  .trim()
                                                                  .isNotEmpty) {
                                                                setState(() {
                                                                  _invalidAnswers[qIndex]
                                                                      ?.remove(
                                                                        aIndex,
                                                                      );
                                                                  if ((_invalidAnswers[qIndex]
                                                                          ?.isEmpty ??
                                                                      true)) {
                                                                    _invalidAnswers
                                                                        .remove(
                                                                          qIndex,
                                                                        );
                                                                  }
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        if (aIndex == 0)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  left: 8,
                                                                ),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    AppColor
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      14,
                                                                    ),
                                                              ),
                                                              child: const Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      vertical:
                                                                          6,
                                                                      horizontal:
                                                                          14,
                                                                    ),
                                                                child: Text(
                                                                  "Answer",
                                                                  style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .blue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (isInvalid)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 6,
                                                            left: 4,
                                                          ),
                                                      child: Text(
                                                        'Answer ${aIndex + 1} is required',
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                ],
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

                              // ------------------ Add Question ------------------
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

                              // ------------------ Publish ------------------
                              AppButton.button(
                                onTap: () async {
                                  HapticFeedback.heavyImpact();

                                  final payload = _validateAndBuildPayload();
                                  if (payload == null) return;

                                  AppLogger.log.i(payload);
                                  await controller.quizCreate(context, payload);
                                },
                                width: 145,
                                height: 60,
                                text: 'Publish',
                                image: AppImages.buttonArrow,
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
