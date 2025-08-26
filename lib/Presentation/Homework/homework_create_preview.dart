import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'controller/create_homework_controller.dart';
import 'homework_history.dart';

class HomeworkCreatePreview extends StatefulWidget {
  final String subjects;
  final List<String> description; // paragraphs (first item used as main)
  final List<File> images;        // additional images from Create screen
  final List<String> listPoints;  // list items
  final File? permanentImage;     // header image from Create screen (optional)
  final String heading;

  final int? subjectId;
  final int? selectedClassId;

  const HomeworkCreatePreview({
    super.key,
    required this.subjects,
    required this.description,
    required this.images,
    required this.listPoints,
    required this.heading,
    this.permanentImage,
    this.subjectId,
    this.selectedClassId,
  });

  @override
  State<HomeworkCreatePreview> createState() => _HomeworkCreatePreviewState();
}

class _HomeworkCreatePreviewState extends State<HomeworkCreatePreview> {
  final CreateHomeworkController homeworkController = Get.put(CreateHomeworkController());

  late DateTime now;
  late String formattedTime;
  late String formattedDate;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _updateTime();
    // Update every minute
    timer = Timer.periodic(const Duration(minutes: 1), (_) => _updateTime());
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

  // ---------- Image helpers ----------

  void _openFullScreen(File file) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 5,
            child: Image.file(file),
          ),
        ),
      ),
    );
  }

  /// Full-width image with rounded corners; keeps aspect ratio without stretching.
  /// Tap to open zoomable fullscreen.
  Widget _previewImage(File file) {
    final screenH = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => _openFullScreen(file),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // Limit height to avoid overly tall images; tweak as you like
            maxHeight: screenH * 0.55,
          ),
          child: Image.file(
            file,
            width: double.infinity,
            fit: BoxFit.contain, // change to BoxFit.cover if you prefer edge-to-edge crop
          ),
        ),
      ),
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final mainDescription = widget.description.isNotEmpty ? widget.description.first : '';
    final extraParagraphs = widget.description.length > 1 ? widget.description.sublist(1) : const <String>[];

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
                const SizedBox(height: 35),
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
                const SizedBox(height: 20),

                // Card
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -------- Images (full width, adjustable) --------
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (widget.permanentImage != null) ...[
                                _previewImage(widget.permanentImage!),
                                const SizedBox(height: 12),
                              ],
                              for (final img in widget.images) ...[
                                _previewImage(img),
                                const SizedBox(height: 12),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // -------- Texts --------
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                widget.heading,
                                style: GoogleFont.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: AppColor.lightBlack,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (mainDescription.trim().isNotEmpty) ...[
                                Text(
                                  mainDescription,
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    color: AppColor.gray,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                              if (extraParagraphs.isNotEmpty)
                                Text(
                                  extraParagraphs.join("\n\n"),
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    color: AppColor.gray,
                                  ),
                                ),
                              const SizedBox(height: 12),

                              if (widget.listPoints.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(widget.listPoints.length, (i) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        '${i + 1}. ${widget.listPoints[i]}',
                                        style: GoogleFont.inter(
                                          fontSize: 12,
                                          color: AppColor.gray,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // -------- Chips --------
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                                        CircleAvatar(child: Image.asset(AppImages.avatar1)),
                                         SizedBox(width: 10),
                                        Text(
                                          widget.subjects,
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
                                        Icon(CupertinoIcons.clock_fill, size: 35, color: AppColor.lightBlack.withOpacity(0.3)),
                                        const SizedBox(width: 10),
                                        Text(
                                          formattedTime,
                                          style: GoogleFont.inter(fontSize: 12, color: AppColor.lightBlack),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          formattedDate,
                                          style: GoogleFont.inter(fontSize: 12, color: AppColor.gray),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                         SizedBox(height: 10),

                        // -------- Actions --------
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.5),
                          child: Row(
                            children: [
                              // Back to Edit
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.lowLightgray,
                                  border: Border.all(color: AppColor.lowLightBlue, width: 1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                                        child: Row(
                                          children: [
                                            Icon(CupertinoIcons.left_chevron, size: 20, color: AppColor.gray),
                                            const SizedBox(width: 11),
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
                              const SizedBox(width: 10),

                              // Publish
                              AppButton.button(
                                onTap: () async {
                                  // Build contents payload:
                                  //  - extra paragraphs (skip first which is `mainDescription`)
                                  //  - list items (each as single string)
                                  final contents = <Map<String, dynamic>>[
                                    ...extraParagraphs
                                        .where((p) => p.trim().isNotEmpty)
                                        .map((p) => {"type": "paragraph", "content": p}),
                                    ...widget.listPoints
                                        .where((l) => l.trim().isNotEmpty)
                                        .map((l) => {"type": "list", "content": l}),
                                  ];

                                  await homeworkController.createHomeWork(
                                    context: context,
                                    showLoader: true,
                                    classId: widget.selectedClassId,
                                    subjectId: widget.subjectId,
                                    heading: widget.heading,
                                    description: mainDescription,
                                    publish: true,
                                    contents: contents,
                                    imageFiles: [
                                      if (widget.permanentImage != null) widget.permanentImage!,
                                      ...widget.images, // files only; controller handles multipart
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
