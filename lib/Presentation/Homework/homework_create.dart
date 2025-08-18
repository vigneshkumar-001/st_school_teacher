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

class _HomeworkCreateState extends State<HomeworkCreate> {
  List<String> _listTextFields = [];
  bool _listSectionOpened = false;
  bool showParagraphField = false;
  List<SectionItem> _sections = [];
  final ImagePicker _picker = ImagePicker();
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

  Future<void> _pickImage(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _sections[index] = SectionItem.image(picked);
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

  int _getTypeIndex(SectionType type, int globalIndex) {
    int count = 0;
    for (int i = 0; i <= globalIndex; i++) {
      if (_sections[i].type == type) {
        count++;
      }
    }
    return count;
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
                        SizedBox(height: 15),
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

                        SizedBox(height: 40),
                        AppButton.button(
                          onTap: () {

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

  Widget _buildImageContainer(SectionItem item, int index) {
    final imageNumber = _getTypeIndex(SectionType.image, index);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image-$imageNumber',
            style: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.black),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final picked = await _picker.pickImage(
                source: ImageSource.gallery,
              );
              if (picked != null) {
                setState(() {
                  item.image = picked;
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

  Widget _buildParagraphContainer(SectionItem item, int index) {
    final paragraphNumber = _getTypeIndex(SectionType.paragraph, index);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description $paragraphNumber',
            style: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.black),
          ),
          SizedBox(height: 6),
          CommonContainer.fillingContainer(
            maxLine: 5,
            text: item.paragraph,
            controller: TextEditingController(text: item.paragraph),
            verticalDivider: false,
            onChanged: (val) => item.paragraph = val,
          ),

          if (showParagraphField) ...[
            CommonContainer.fillingContainer(
              maxLine: 10,
              text: '',
              controller: Description,
              verticalDivider: false,
            ),
          ],
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
          Text(
            'List $listNumber',
            style: GoogleFont.ibmPlexSans(fontSize: 14, color: AppColor.black),
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

  String _getSuffix(int number) {
    if (number == 1) return "st";
    if (number == 2) return "nd";
    if (number == 3) return "rd";
    return "th";
  }
}
