import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Presentation/Homework/controller/create_homework_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'homework_history.dart';
import 'package:get/get.dart';

class HomeworkCreatePreview extends StatefulWidget {
  final String subjects;
  final List<String> description; // paragraphs
  final List<File> images;

  final List<String> listPoints;
  final File? permanentImage;

  final String heading;

  final int? subjectId;
  final int? selectedClassId;
  const HomeworkCreatePreview({
    super.key,
    required this.subjects,
    required this.description,
    this.permanentImage, // 👈 optional
    required this.heading,
    this.subjectId,
    required this.images,
    required this.listPoints,
    this.selectedClassId,
    // File?permanentImage,
  });

  @override
  State<HomeworkCreatePreview> createState() => _HomeworkCreatePreviewState();
}

class _HomeworkCreatePreviewState extends State<HomeworkCreatePreview> {
  late DateTime now;
  late String formattedTime;
  late String formattedDate;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _updateTime();

    // Optional: Update time every minute (or every second if you want)
    timer = Timer.periodic(Duration(seconds: 60), (_) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      now = DateTime.now();
      formattedTime = DateFormat('h.mm a').format(now);
      formattedDate = DateFormat('dd.MMM.yy').format(now);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final CreateHomeworkController homeworkController = Get.put(
    CreateHomeworkController(),
  );
  List<Map<String, dynamic>> contents = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                    'Homework Preview',
                    style: GoogleFont.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    // gradient: LinearGradient(
                    //   colors: [
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow,
                    //     AppColor.lowLightYellow.withOpacity(0.2),
                    //   ], // gradient top to bottom
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    // ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  if (widget.permanentImage != null)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        widget.permanentImage!,
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                    ),
                                  widget.images != null &&
                                          widget.images.isNotEmpty
                                      ? Column(
                                        children:
                                            widget.images.map((img) {
                                              return Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Image.file(
                                                  img, // ✅ Directly pass File
                                                  fit: BoxFit.cover,
                                                  height: 200,
                                                  width: double.infinity,
                                                ),
                                              );
                                            }).toList(),
                                      )
                                      : const SizedBox.shrink(),
                                ],
                              ),

                              SizedBox(height: 20),
                              // Image.asset(AppImages.homeworkPreviewImage2),
                              // SizedBox(height: 20),
                              Text(
                                widget.heading ?? '',
                                style: GoogleFont.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: AppColor.lightBlack,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                widget.description.join(
                                  ",\n",
                                ), // new line separated
                                style: GoogleFont.inter(
                                  fontSize: 12,
                                  color: AppColor.gray,
                                ),
                              ),
                              SizedBox(height: 15),

                              if (widget.listPoints != null &&
                                  widget.listPoints.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    widget.listPoints.length,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                        ),
                                        child: Text(
                                          '${index + 1}. ${widget.listPoints[index]}',
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.gray,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 25,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.black.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          child: Image.asset(AppImages.avatar1),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          widget.subjects ?? '',
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.lightBlack,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.black.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.clock_fill,
                                          size: 35,
                                          color: AppColor.lightBlack
                                              .withOpacity(0.3),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          formattedTime,
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.lightBlack,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          formattedDate,
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.gray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.5),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.lowLightgray,
                                  border: Border.all(
                                    color: AppColor.lowLightBlue,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 9,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              color: AppColor.gray,
                                              CupertinoIcons.left_chevron,
                                              size: 20,
                                            ),
                                            SizedBox(width: 11),
                                            Text(
                                              'Back to Edit',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.gray,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              /*    AppButton.button(
                                onTap: () async {
                                  List<Map<String, dynamic>> contents = [];

                                  // Add lists to contents
                                  for (var listItem in widget.listPoints) {
                                    if (listItem is List<String>) {
                                      contents.add({
                                        "type": "list",
                                        "content": listItem,
                                      });
                                    } else if (listItem is String) {
                                      contents.add({
                                        "type": "list",
                                        "content": listItem,
                                      });
                                    }
                                  }

                                  if (widget.description.length > 1) {
                                    for (
                                      var i = 1;
                                      i < widget.description.length;
                                      i++
                                    ) {
                                      var para = widget.description[i];
                                      if (para.trim().isNotEmpty) {
                                        contents.add({
                                          "type": "paragraph",
                                          "content": para,
                                        });
                                      }
                                    }
                                  }

                                  String mainDescription =
                                      widget.description.isNotEmpty
                                          ? widget.description[0]
                                          : '';
                                  for (var image
                                      in widget.images.whereType<File>()) {
                                    contents.add({
                                      "type": "image",
                                      "content":
                                          image
                                              .path, // or just include the file for backend upload
                                    });
                                  }
                                  await homeworkController.createHomeWork(
                                    showLoader: true,
                                    classId: widget.selectedClassId,
                                    subjectId: widget.subjectId,
                                    heading: widget.heading ?? '',
                                    description: mainDescription,
                                    publish: true,
                                    contents: contents,
                                    imageFiles:
                                        widget.images
                                            .whereType<File>()
                                            .toList(),
                                  );
                                },

                                width: 145,
                                height: 60,
                                text: 'Publish',
                                image: AppImages.buttonArrow,
                              ),*/
                              AppButton.button(
                                onTap: () async {
                                  List<Map<String, dynamic>> contents = [];

                                  // Add list items
                                  for (var listItem in widget.listPoints) {
                                    contents.add({
                                      "type": "list",
                                      "content": listItem,
                                    });
                                  }

                                  // Add paragraph contents
                                  if (widget.description.length > 1) {
                                    for (
                                      var i = 1;
                                      i < widget.description.length;
                                      i++
                                    ) {
                                      var para = widget.description[i];
                                      if (para.trim().isNotEmpty) {
                                        contents.add({
                                          "type": "paragraph",
                                          "content": para,
                                        });
                                      }
                                    }
                                  }

                                  // First description goes to 'description' field
                                  String mainDescription =
                                      widget.description.isNotEmpty
                                          ? widget.description[0]
                                          : '';

                                  // Only pass files for upload, do NOT add their paths manually
                                  await homeworkController.createHomeWork(
                                    context: context,
                                    showLoader: true,
                                    classId: widget.selectedClassId,
                                    subjectId: widget.subjectId,
                                    heading: widget.heading ?? '',
                                    description: mainDescription,
                                    publish: true,
                                    contents: contents,
                                    imageFiles: [
                                      if (widget.permanentImage != null)
                                        widget.permanentImage!,
                                      ...widget.images.whereType<File>(),
                                    ],
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
