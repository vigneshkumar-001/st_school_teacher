import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:st_teacher_app/Core/Utility/custom_app_button.dart';
import 'package:st_teacher_app/Presentation/Homework/controller/teacher_class_controller.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'homework_create_preview.dart';
import 'package:get/get.dart';

import 'homework_history.dart';

enum SectionType { image, paragraph, list }

class SectionItem {
  final SectionType type;
  XFile? image;
  String paragraph;
  List<String> listPoints;

  SectionItem.image(this.image)
    : type = SectionType.image,
      paragraph = '',
      listPoints = [];

  SectionItem.paragraph(this.paragraph)
    : type = SectionType.paragraph,
      image = null,
      listPoints = [];

  SectionItem.list(this.listPoints)
    : type = SectionType.list,
      image = null,
      paragraph = '';
}

class HomeworkCreate extends StatefulWidget {
  const HomeworkCreate({super.key});

  @override
  State<HomeworkCreate> createState() => _HomeworkCreateState();
}

class _HomeworkCreateState extends State<HomeworkCreate> {
  List<String> _listTextFields = [];
  List<TextEditingController> descriptionControllers = [];
  bool _listSectionOpened = false;
  bool showParagraphField = false;
  List<SectionItem> _sections = [];
  int selectedIndex = 0;
  int subjectIndex = 0;
  String? selectedSubject;
  int? selectedSubjectId;
  int? selectedClassId;
  XFile? _permanentImage;
  final List<XFile?> _pickedImages = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController Description = TextEditingController();
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImages.add(picked);
      });
    }
  }

  Future<void> _pickPermanentImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _permanentImage = picked; // store it in the single field
      });
    }
  }

  final TeacherClassController teacherClassController = Get.put(
    TeacherClassController(),
  );

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
    });
  }

  void _openListSection() {
    if (!_listSectionOpened) {
      setState(() {
        _listSectionOpened = true;
        _listTextFields.add('');
      });
    }
  }

  void _addMoreListPoint() {
    setState(() {
      _listTextFields.add('');
    });
  }

  void _removeListItem(int index) {
    setState(() {
      _listTextFields.removeAt(index);

      if (_listTextFields.isEmpty) {
        _listSectionOpened = false;
      }
    });
  }

  bool showClearIcon = false;
  TextEditingController headingController = TextEditingController();

  void addDescriptionField() {
    setState(() {
      descriptionControllers.add(TextEditingController());
    });
  }

  // Remove a description at index
  void removeDescriptionField(int index) {
    setState(() {
      descriptionControllers[index].dispose(); // prevent memory leak
      descriptionControllers.removeAt(index);
    });
  }

  int _getTypeIndex(SectionType type, int globalIndex) {
    int count = 0;
    for (int i = 0; i <= globalIndex; i++) {
      if (_sections[i].type == type) {
        count++;
      }
    }
    return count;
  }

  @override
  void initState() {
    super.initState();

    teacherClassController.getTeacherClass().then((_) {
      if (teacherClassController.classList.isNotEmpty) {
        selectedClassId = teacherClassController.classList[0].id;
        selectedIndex = 0;
      }
      if (teacherClassController.subjectList.isNotEmpty) {
        selectedSubjectId = teacherClassController.subjectList[0].id;
        subjectIndex = 0;
        selectedSubject = teacherClassController.subjectList[0].name;
      }
      setState(() {}); // update UI after setting defaults
    });

    descriptionControllers.add(TextEditingController());

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
    // {'grade': '8', 'section': 'A'},
    // {'grade': '8', 'section': 'B'},
    // {'grade': '8', 'section': 'C'},
    // {'grade': '9', 'section': 'A'},
    // {'grade': '9', 'section': 'C'},
  ];

  final List<Map<String, dynamic>> tabs = [
    {"label": "Social Science"},
    {"label": "English"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
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
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeworkHistory(),
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
                                    itemCount:
                                        teacherClassController.classList.length,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item =
                                          teacherClassController
                                              .classList[index];
                                      final grade = item.name;
                                      final section = item.section;
                                      final isSelected = index == selectedIndex;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                            selectedClassId = item.id;
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
                                                              '${grade}',
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
                            children: List.generate(
                              teacherClassController.subjectList.length,
                              (index) {
                                final sub =
                                    teacherClassController.subjectList[index];
                                final isSelected = subjectIndex == index;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        subjectIndex = index;
                                        selectedSubject = sub.name;
                                        selectedSubjectId = sub.id;
                                      });
                                    },
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
                                            sub.name,
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
                              },
                            ),
                          ),
                          SizedBox(height: 25),
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
                          Column(
                            children: List.generate(
                              descriptionControllers.length,
                              (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Description',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 14,
                                            color: AppColor.black,
                                          ),
                                        ),
                                        // InkWell(
                                        //   onTap:
                                        //       () =>
                                        //           removeDescriptionField(index),
                                        //   child: Image.asset(
                                        //     AppImages.close,
                                        //     height: 26,
                                        //     color: AppColor.gray,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    CommonContainer.fillingContainer(
                                      maxLine: 10,
                                      text: '',
                                      controller: descriptionControllers[index],
                                      verticalDivider: false,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              },
                            ),
                          ),

                          //
                          // if (showParagraphField) ...[
                          //   const SizedBox(height: 16),
                          //   Text(
                          //     'Description',
                          //     style: GoogleFont.ibmPlexSans(
                          //       fontSize: 14,
                          //       color: AppColor.black,
                          //     ),
                          //   ),
                          //   const SizedBox(height: 10),
                          //   CommonContainer.fillingContainer(
                          //     maxLine: 10,
                          //     text: '',
                          //     controller: ,
                          //     verticalDivider: false,
                          //   ),
                          // ],
                          if (_pickedImages.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 28.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(_pickedImages.length, (
                                    index,
                                  ) {
                                    final imageFile = _pickedImages[index];

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),

                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Image-${index + 1}',
                                                style: GoogleFont.ibmPlexSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColor.black,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _pickedImages.removeAt(
                                                      index,
                                                    );
                                                  });
                                                },
                                                child: Image.asset(
                                                  AppImages.close,
                                                  height: 26,
                                                  color: AppColor.gray,
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 10),
                                          GestureDetector(
                                            onTap: () async {
                                              final picked = await _picker
                                                  .pickImage(
                                                    source: ImageSource.gallery,
                                                  );
                                              if (picked != null) {
                                                setState(() {
                                                  _pickedImages[index] = picked;
                                                });
                                              }
                                            },
                                            child: DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: const Radius.circular(20),
                                              color: AppColor.lightgray,
                                              strokeWidth: 1.5,
                                              dashPattern: const [8, 4],
                                              padding: const EdgeInsets.all(1),
                                              child: Container(
                                                height: 120,
                                                padding: EdgeInsets.symmetric(
                                                  // vertical: 12,
                                                  horizontal: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColor.lightWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  children: [
                                                    if (imageFile == null)
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                              AppImages
                                                                  .uploadImage,
                                                              height: 30,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              'Upload',
                                                              style: GoogleFont.ibmPlexSans(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    AppColor
                                                                        .lightgray,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    else ...[
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        child: Image.file(
                                                          File(imageFile.path),
                                                          width: 200,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 35.0,
                                                            ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                    right: 10.0,
                                                                  ),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _pickedImages
                                                                        .removeAt(
                                                                          index,
                                                                        );
                                                                  });
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Image.asset(
                                                                      AppImages
                                                                          .close,
                                                                      height:
                                                                          26,
                                                                      color:
                                                                          AppColor
                                                                              .gray,
                                                                    ),
                                                                    Text(
                                                                      'Clear',
                                                                      style: GoogleFont.ibmPlexSans(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color:
                                                                            AppColor.lightgray,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // IconButton(
                                                              //   icon:  Icon(Icons.clear, size: 26),
                                                              //   color: AppColor.lightgray,
                                                              //   onPressed: () {
                                                              //     setState(() {
                                                              //       _pickedImages.removeAt(index);
                                                              //     });
                                                              //   },
                                                              // ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          SizedBox(height: 20),
                          if (_listSectionOpened) ...[
                            Text(
                              'List',
                              style: GoogleFont.ibmPlexSans(
                                // fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 12),

                            ListView.builder(
                              itemCount: _listTextFields.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.lightWhite,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'List ${index + 1}',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 14,
                                            color: AppColor.gray,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
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
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintStyle: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                color: AppColor.gray,
                                              ),
                                              // hintText: 'List ${index + 1}',
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              _listTextFields[index] = value;
                                            },
                                          ),
                                        ),

                                        SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => _removeListItem(index),
                                          child: Image.asset(
                                            AppImages.close,
                                            height: 26,
                                            color: AppColor.gray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

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
                                    'Add List ${_listTextFields.length + 1} Point',
                                    style: GoogleFont.ibmPlexSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColor.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 25),
                          ListView.builder(
                            itemCount: _sections.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = _sections[index];

                              switch (item.type) {
                                case SectionType.image:
                                  return _buildImageContainer(item, index);
                                case SectionType.paragraph:
                                  return _buildParagraphContainer(item, index);
                                case SectionType.list:
                                  return _buildListContainer(item, index);
                              }
                            },
                          ),

                          SizedBox(height: 25),
                          Row(
                            children: [
                              Text(
                                'Add',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 14,
                                  color: AppColor.black,
                                ),
                              ),
                              SizedBox(width: 25),

                              CommonContainer.addMore(
                                onTap: () {
                                  setState(() {
                                    _sections.add(SectionItem.image(null));
                                  });
                                },
                                mainText: 'Image',
                                imagePath: AppImages.picherImageDark,
                              ),
                              SizedBox(width: 10),

                              CommonContainer.addMore(
                                onTap: () {
                                  setState(() {
                                    _sections.add(SectionItem.paragraph(''));
                                  });
                                },
                                mainText: 'Paragraph',
                                imagePath: AppImages.paragraph,
                              ),
                              SizedBox(width: 10),

                              CommonContainer.addMore(
                                onTap: () {
                                  setState(() {
                                    _sections.add(SectionItem.list(['']));
                                  });
                                },
                                mainText: 'List',
                                imagePath: AppImages.list,
                              ),
                            ],
                          ),

                          /*     Row(
                            children: [
                              Text(
                                'Add',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 14,
                                  color: AppColor.black,
                                ),
                              ),
                              SizedBox(width: 25),
                              CommonContainer.addMore(
                                onTap: () {
                                  setState(() {
                                    _pickedImages.add(null);
                                  });
                                },
                                mainText: 'Image',
                                imagePath: AppImages.picherImageDark,
                              ),
                              SizedBox(width: 10),
                              CommonContainer.addMore(
                                onTap: () {
                                  setState(() {
                                    descriptionControllers.add(
                                      TextEditingController(),
                                    );
                                  });
                                },
                                mainText: 'Paragraph',
                                imagePath: AppImages.paragraph,
                              ),

                              SizedBox(width: 10),
                              CommonContainer.addMore(
                                onTap: _openListSection,
                                mainText: 'List',
                                imagePath: AppImages.list,
                              ),
                            ],
                          ),*/
                          SizedBox(height: 40),
                          AppButton.button(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => HomeworkCreatePreview(
                                        listPoints: _listTextFields,
                                        subjectId: selectedSubjectId,
                                        selectedClassId: selectedClassId,
                                        subjects: selectedSubject ?? '',
                                        description: [
                                          // take from old descriptionControllers
                                          ...descriptionControllers
                                              .map(
                                                (controller) => controller.text,
                                              )
                                              .where(
                                                (text) =>
                                                    text.trim().isNotEmpty,
                                              ),

                                          // also take from _sections
                                          ..._sections
                                              .where(
                                                (s) =>
                                                    s.type ==
                                                        SectionType.paragraph &&
                                                    s.paragraph
                                                        .trim()
                                                        .isNotEmpty,
                                              )
                                              .map((s) => s.paragraph),
                                        ],

                                        images:
                                            _sections
                                                .where(
                                                  (s) =>
                                                      s.type ==
                                                          SectionType.image &&
                                                      s.image != null,
                                                )
                                                .map((s) => File(s.image!.path))
                                                .toList(),

                                        permanentImage:
                                            _permanentImage != null
                                                ? File(_permanentImage!.path)
                                                : null,
                                        heading: headingController.text,
                                      ),
                                ),
                              );
                            },
                            width: 145,
                            height: 60,
                            text: 'Preview',
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

  Widget _buildParagraphContainer(SectionItem item, int index) {
    final paragraphNumber = _getTypeIndex(SectionType.paragraph, index);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Description $paragraphNumber',
                style: GoogleFont.ibmPlexSans(
                  fontSize: 14,
                  color: AppColor.black,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _sections.removeAt(index);
                  });
                },
                child: Image.asset(
                  AppImages.close,
                  height: 26,
                  color: AppColor.gray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          CommonContainer.fillingContainer(
            maxLine: 5,
            text: item.paragraph,
            controller: null,
            verticalDivider: false,
            onChanged: (val) {
              setState(() {
                item.paragraph = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListContainer(SectionItem item, int index) {
    final listNumber = _getTypeIndex(SectionType.list, index);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'List $listNumber',
                style: GoogleFont.ibmPlexSans(
                  fontSize: 14,
                  color: AppColor.black,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _sections.removeAt(index); // remove this image section
                  });
                },
                child: Image.asset(
                  AppImages.close,
                  height: 26,
                  color: AppColor.gray,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          ListView.builder(
            itemCount: item.listPoints.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, listIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.lightWhite,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'List ${listIndex + 1}',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 14,
                          color: AppColor.gray,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
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
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintStyle: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.gray,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            item.listPoints[listIndex] = value;
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            item.listPoints.removeAt(listIndex);
                          });
                        },
                        child: Image.asset(
                          AppImages.close,
                          height: 26,
                          color: AppColor.gray,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          GestureDetector(
            onTap: () {
              setState(() {
                item.listPoints.add('');
              });
            },
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
                  'Add List ${item.listPoints.length + 1} Point',
                  style: GoogleFont.ibmPlexSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColor.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(SectionItem item, int index) {
    final imageNumber = _getTypeIndex(SectionType.image, index);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Image-$imageNumber',
                style: GoogleFont.ibmPlexSans(
                  fontSize: 14,
                  color: AppColor.black,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _sections.removeAt(index); // remove this image section
                  });
                },
                child: Image.asset(
                  AppImages.close,
                  height: 26,
                  color: AppColor.gray,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Upload box
          GestureDetector(
            onTap: () async {
              final picked = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (picked != null) {
                setState(() {
                  item.image = picked; // ✅ only keep inside SectionItem
                });
              }
            },
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(20),
              color: AppColor.lightgray,
              strokeWidth: 1.5,
              dashPattern: const [8, 4],
              padding: const EdgeInsets.all(1),
              child: Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColor.lightWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (item.image == null)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(AppImages.uploadImage, height: 30),
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
                          File(item.image!.path),
                          width: 200,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    item.image = null;
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
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
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
