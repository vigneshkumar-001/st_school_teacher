import 'package:dotted_border/dotted_border.dart';
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
}
