import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_textfield.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';

class QuizDetails extends StatefulWidget {

  const QuizDetails({super.key});

  @override
  State<QuizDetails> createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  Map<int, String> selectedAnswers = {};
  int questionIndex = 0;
  int selectedAnswerIndexQ1 = -1;
  int selectedAnswerIndexQ2 = -1;
  bool isQuizCompleted = false;

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
                CommonContainer.NavigatArrow(
                  image: AppImages.leftSideArrow,
                  imageColor: AppColor.lightBlack,
                  container: AppColor.lowLightgray,
                  onIconTap: () => Navigator.pop(context),
                  border: Border.all(color: AppColor.lightgray, width: 0.3),
                ),
                SizedBox(height: 35),
                Center(
                  child: Text(
                    'Lorem ipsum donae',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 25),
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
                        SizedBox(height: 15),
                        CommonContainer.quizContainer(
                          isQuizCompleted: isQuizCompleted,
                          leftTextNumber: 'A',
                          leftValue: '11',
                          rightTextNumber: 'B',
                          rightValue: "12",
                          leftSelected: selectedAnswerIndexQ1 == 0,
                          rightSelected: selectedAnswerIndexQ1 == 1,
                          leftOnTap: () {
                            setState(() {
                              selectedAnswerIndexQ1 = 0;
                            });
                          },
                          rightOnTap: () {
                            setState(() {
                              selectedAnswerIndexQ1 = 1;
                            });
                          },
                        ),
                        SizedBox(height: 20),

                        CommonContainer.quizContainer(
                          isQuizCompleted: isQuizCompleted,
                          leftTextNumber: 'C',
                          leftValue: '13',
                          rightTextNumber: 'D',
                          rightValue: "14",
                          leftSelected: selectedAnswerIndexQ1 == 2,
                          rightSelected: selectedAnswerIndexQ1 == 3,
                          leftOnTap: () {
                            setState(() {
                              selectedAnswerIndexQ1 = 2;
                            });
                          },
                          rightOnTap: () {
                            setState(() {
                              selectedAnswerIndexQ1 = 3;
                            });
                          },
                        ),
                        SizedBox(height: 35),
                        CustomTextField.quizQuestion(
                          sno: '2.',
                          text: 'What is the value of 5 × 3?',
                        ),

                        SizedBox(height: 15),
                        CommonContainer.quizContainer(
                          isQuizCompleted: isQuizCompleted,
                          leftTextNumber: 'A',
                          leftValue: '11',
                          rightTextNumber: 'B',
                          rightValue: "12",
                          leftSelected: selectedAnswerIndexQ2 == 0,
                          rightSelected: selectedAnswerIndexQ2 == 1,
                          leftOnTap: () {
                            setState(() {
                              selectedAnswerIndexQ2 = 0;
                            });
                          },
                          rightOnTap: () {
                            setState(() {
                              selectedAnswerIndexQ2 = 1;
                            });
                          },
                        ),
                        SizedBox(height: 20),

                        CommonContainer.quizContainer(
                          isQuizCompleted: isQuizCompleted,
                          leftSelected: selectedAnswerIndexQ2 == 2,
                          rightSelected: selectedAnswerIndexQ2 == 3,
                          leftTextNumber: 'C',
                          leftValue: '13',
                          rightTextNumber: 'D',
                          rightValue: "14",
                          leftOnTap: () {
                            setState(() {
                              selectedAnswerIndexQ2 = 2;
                            });
                          },
                          rightOnTap: () {
                            setState(() {
                              selectedAnswerIndexQ2 = 3;
                            });
                          },
                        ),
                        SizedBox(height: 35),
                        CustomTextField.quizQuestion(
                          sno: '3.',
                          text:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                        ),
                        SizedBox(height: 20),
                        CommonContainer.quizContainer1(
                          isQuizCompleted: isQuizCompleted,
                          isSelected: selectedAnswers[questionIndex] == 'A',
                          onTap: () {
                            setState(() {
                              selectedAnswers[questionIndex] = 'A';
                            });
                          },
                          leftTextNumber: 'A',
                          leftValue:
                              'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                        ),
                        SizedBox(height: 20),

                        CommonContainer.quizContainer1(
                          isQuizCompleted: isQuizCompleted,
                          isSelected: selectedAnswers[questionIndex] == 'B',
                          onTap: () {
                            setState(() {
                              selectedAnswers[questionIndex] = 'B';
                            });
                          },
                          leftTextNumber: 'B',
                          leftValue:
                              'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                        ),
                        SizedBox(height: 20),

                        CommonContainer.quizContainer1(
                          isQuizCompleted: isQuizCompleted,
                          isSelected: selectedAnswers[questionIndex] == 'C',
                          onTap: () {
                            setState(() {
                              selectedAnswers[questionIndex] = 'C';
                            });
                          },
                          leftTextNumber: 'C',
                          leftValue:
                              'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                        ),
                        SizedBox(height: 20),

                        CommonContainer.quizContainer1(
                          isQuizCompleted: isQuizCompleted,
                          isSelected: selectedAnswers[questionIndex] == 'D',
                          onTap: () {
                            setState(() {
                              selectedAnswers[questionIndex] = 'D';
                            });
                          },
                          leftTextNumber: 'D',
                          leftValue:
                              'Sed egestas gravida cursus. Vivamus molestie fermentum dolor at consectetur.',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),

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
                          SizedBox(height: 4),
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
                              SizedBox(width: 10),
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
        ),
      ),
    );
  }
}
