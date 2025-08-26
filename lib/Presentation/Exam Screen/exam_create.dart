import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:st_teacher_app/Core/Utility/custom_app_button.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../Homework/controller/teacher_class_controller.dart';
import 'exam_history.dart';

class ExamCreate extends StatefulWidget {
  const ExamCreate({super.key});

  @override
  State<ExamCreate> createState() => _ExamCreateState();
}

class _ExamCreateState extends State<ExamCreate> {
  int selectedIndex = 0;
  int? selectedClassId;
  bool showClearIcon = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _permanentImage;
  TextEditingController headingController = TextEditingController();
  final TextEditingController dateRangeController = TextEditingController();
  final TextEditingController singleDateController = TextEditingController();
  final List<Map<String, String>> classData = [
    {'grade': '8', 'section': 'A'},
    {'grade': '8', 'section': 'B'},
    {'grade': '8', 'section': 'C'},
    {'grade': '9', 'section': 'A'},
    {'grade': '9', 'section': 'C'},
  ];
  Future<void> _pickPermanentImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _permanentImage = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            builder: (context) => ExamHistory(),
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
                          SizedBox(width: 8),
                          Image.asset(AppImages.historyImage, height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Text(
                  'Create Exam',
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
                                                      SizedBox(height: 10),
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
                        SizedBox(height: 25),

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
                          'Start & End Date',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        CommonContainer.studentInfoScreen(
                          text: '',
                          controller: dateRangeController,
                          context: context,
                          imagePath: AppImages.calander,
                          verticalDivider: true,
                          datePickMode: DatePickMode.range,
                          styledRangeText: true,
                        ),

                        SizedBox(height: 25),
                        Text(
                          'Announcement Date',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        CommonContainer.studentInfoScreen(
                          text: 'Date',
                          controller: singleDateController,
                          context: context,
                          imagePath: AppImages.calander,
                          verticalDivider: true,
                          datePickMode: DatePickMode.single,
                          styledRangeText: false,
                        ),
                        SizedBox(height: 25),
                        Text(
                          'Timetable',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: _pickPermanentImage,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(20),
                            color: AppColor.lightgray,
                            strokeWidth: 1.5,
                            dashPattern: const [8, 4],
                            padding: const EdgeInsets.all(1),
                            child: Container(
                              height: 120,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.lightWhite,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  if (_permanentImage == null)
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AppImages.uploadImage,
                                            height: 30,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Upload',
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.lightgray,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  else ...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(_permanentImage!.path),
                                        width: 200,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 35.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _permanentImage = null;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              AppImages.close,
                                              height: 26,
                                              color: AppColor.gray,
                                            ),
                                            Text(
                                              'Clear',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.lightgray,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        AppButton.button(
                          text: 'Submit',
                          image: AppImages.buttonArrow,
                          width: 139,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExamHistory(),
                              ),
                            );
                          },
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
