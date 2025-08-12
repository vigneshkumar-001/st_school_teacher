import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:st_teacher_app/Core/Utility/custom_app_button.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'homework_create_preview.dart';
import 'homework_history.dart';

class HomeworkCreate extends StatefulWidget {
  const HomeworkCreate({super.key});

  @override
  State<HomeworkCreate> createState() => _HomeworkCreateState();
}

class _HomeworkCreateState extends State<HomeworkCreate> {
  List<String> _listTextFields = [];
  bool _listSectionOpened = false;
  bool showParagraphField = false;

  XFile? _permanentImage;

  Future<void> _pickPermanentImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _permanentImage = picked;
      });
    }
  }

  final List<XFile?> _pickedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImages[index] = picked;
        if (index == _pickedImages.length - 1) {
          _pickedImages.add(null);
        }
      });
    }
  }

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
                        Text(
                          'Description',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        CommonContainer.fillingContainer(
                          maxLine: 10,
                          text: '',
                          controller: Description,
                          verticalDivider: false,
                        ),



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
                                    padding: const EdgeInsets.only(bottom: 14),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Image-${index + 1}',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.black,
                                          ),
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
                                                                    height: 26,
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
                                                                          FontWeight
                                                                              .w400,
                                                                      color:
                                                                          AppColor
                                                                              .lightgray,
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
                        if (showParagraphField) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Description',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CommonContainer.fillingContainer(
                            maxLine: 10,
                            text: '',
                            controller: Description,
                            verticalDivider: false,
                          ),
                        ],
                        SizedBox(height: 20),
                        if (_listSectionOpened) ...[
                          Text(
                            'List',
                            style: GoogleFont.ibmPlexSans(

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
                                  showParagraphField = !showParagraphField;
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
