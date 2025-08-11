import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Homework/homework_create_preview.dart';

class QuestionModel {
  String question = '';
  List<String> answers = List.generate(4, (_) => '');
}

class QuizScreenCreate extends StatefulWidget {
  const QuizScreenCreate({super.key});

  @override
  State<QuizScreenCreate> createState() => _QuizScreenCreateState();
}

class _QuizScreenCreateState extends State<QuizScreenCreate> {
  List<QuestionModel> questionList = [];

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

  bool _listSectionOpened = false;
  bool showParagraphField = false;

  void _addMoreListPoint() {
    setState(() {
      questionList.add(QuestionModel());
    });
  }

  bool showClearIcon = false;
  TextEditingController headingController = TextEditingController();
  TextEditingController Question = TextEditingController();
  final TextEditingController Description = TextEditingController();

  @override
  void initState() {
    super.initState();
    headingController.addListener(() {
      setState(() {
        showClearIcon = headingController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    headingController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> classData = [
    {'grade': '8', 'section': 'A'},
    {'grade': '8', 'section': 'B'},
    {'grade': '8', 'section': 'C'},
    {'grade': '9', 'section': 'A'},
    {'grade': '9', 'section': 'C'},
  ];

  int selectedIndex = 0;
  int subjectIndex = 0;

  final List<Map<String, dynamic>> tabs = [
    {"label": "Social Science"},
    {"label": "English"},
  ];

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
                    Text(
                      'History',
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
                SizedBox(height: 35),
                Text(
                  'Create Homework',
                  style: GoogleFont.ibmPlexSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: AppColor.black,
                  ),
                ),
                SizedBox(height: 20),

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
                        Text(
                          'Class',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 20),
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
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 40),
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
                                                      offset: Offset(0, 4),
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
                                                    SizedBox(height: 8),
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
                                                                  AppColor.blue,
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
                                                                  bounds.width,
                                                                  bounds.height,
                                                                ),
                                                              ),
                                                          blendMode:
                                                              BlendMode.srcIn,
                                                          child: Text(
                                                            '${grade}',
                                                            style:
                                                                GoogleFont.ibmPlexSans(
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
                                                                BlendMode.srcIn,
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
                                                        gradient:
                                                            LinearGradient(
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
                                                          color: AppColor.white,
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
                                                        style:
                                                            GoogleFont.ibmPlexSans(
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
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 40),
                        Text(
                          'Subject',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: List.generate(tabs.length, (index) {
                            final isSelected = subjectIndex == index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: GestureDetector(
                                onTap:
                                    () => setState(() => subjectIndex = index),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSelected ? 25 : 35,
                                    vertical: isSelected ? 14 : 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? AppColor.white
                                            : AppColor.white,
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
                                      isSelected
                                          ? Image.asset(
                                            AppImages.tick,
                                            height: 15,
                                            color: AppColor.blue,
                                          )
                                          : SizedBox.shrink(),
                                      SizedBox(width: isSelected ? 10 : 0),
                                      Text(
                                        " ${tabs[index]['label']}",
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 12,
                                          color:
                                              isSelected
                                                  ? AppColor.blue
                                                  : AppColor.gray,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 25),
                        Text(
                          'Heading',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        CommonContainer.fillingContainer(
                          onDetailsTap: () {
                            headingController.clear();
                            setState(() {
                              showClearIcon = false;
                            });
                          },
                          imagePath: showClearIcon ? AppImages.close : null,
                          imageColor: AppColor.gray,
                          text: '',
                          controller: headingController,

                          verticalDivider: false,
                        ),
                        SizedBox(height: 25),
                        Text(
                          'Time Limit',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        CommonContainer.fillingContainer(
                          imagePath: AppImages.clock,
                          imageColor: AppColor.lightgray,
                          // maxLine: 10,
                          text: '',
                          controller: Description,
                          verticalDivider: false,
                        ),
                        SizedBox(height: 25),
                        ListView.builder(
                          itemCount: questionList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, qIndex) {
                            final question = questionList[qIndex];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  SizedBox(height: 20),
                                  Text(
                                    'Question',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CommonContainer.fillingContainer(
                                    onDetailsTap: () {
                                      Question.clear();
                                      setState(() {
                                        showClearIcon = false;
                                      });
                                    },
                                    imagePath:
                                        showClearIcon ? AppImages.close : null,
                                    imageColor: AppColor.gray,

                                    maxLine: 10,
                                    text: question.question,
                                    controller: TextEditingController(
                                      text: question.question,
                                    ),
                                    verticalDivider: false,
                                    onChanged: (val) => question.question = val,
                                  ),
                                   SizedBox(height: 16),
                                  Text(
                                    'Answer',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                   SizedBox(height: 10),
                                  ListView.builder(
                                    itemCount: 4,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
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
                                          ),
                                          child:Row(
                                            children: [

                                              Expanded(
                                                child: Stack(
                                                  children: [
                                                    TextField(
                                                      decoration: InputDecoration(
                                                        hintText: 'List ${index + 1}',
                                                        hintStyle: GoogleFont.ibmPlexSans(
                                                          fontSize: 14,
                                                          color: AppColor.gray,
                                                        ),
                                                        border: InputBorder.none,
                                                        contentPadding: EdgeInsets.only(right: 20),
                                                      ),
                                                      controller: TextEditingController(
                                                        text: question.answers[index],
                                                      ),
                                                      onChanged: (value) {
                                                        question.answers[index] = value;
                                                      },
                                                    ),

                                                    // Positioned Divider
                                                    Positioned(
                                                      right: 210,
                                                      top: 10,
                                                      bottom: 10,

                                                      child: Container(
                                                        width: 2,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [
                                                              Colors.grey.shade200,
                                                              Colors.grey.shade300,
                                                              Colors.grey.shade200,
                                                            ],
                                                          ),
                                                          borderRadius: BorderRadius.circular(
                                                            1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                              SizedBox(width: 8),
                                              GestureDetector(
                                                // onTap: () => _removeListItem(index),
                                                child: Image.asset(
                                                  AppImages.close,
                                                  height: 26,
                                                  color: AppColor.gray,
                                                ),
                                              ),
                                            ],
                                          )




                                        ),
                                      );
                                    },
                                  ),
                                  Divider(),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 25),

                        GestureDetector(
                          onTap: _addMoreListPoint,
                          child: DottedBorder(
                            color: AppColor.blue,
                            strokeWidth: 1.5,
                            dashPattern: [8, 4],
                            borderType: BorderType.RRect,
                            radius: Radius.circular(20),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14),
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

                        SizedBox(height: 40),
                        AppButton.button(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeworkCreatePreview(),
                              ),
                            );
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

  String _getSuffix(int number) {
    if (number == 1) return "st";
    if (number == 2) return "nd";
    if (number == 3) return "rd";
    return "th";
  }
}
