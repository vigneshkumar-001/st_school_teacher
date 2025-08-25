import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:st_teacher_app/Presentation/Homework/controller/create_homework_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'package:get/get.dart';

class HomeworkHistoryDetails extends StatefulWidget {
  final int homeworkId;
  const HomeworkHistoryDetails({super.key, required this.homeworkId});

  @override
  State<HomeworkHistoryDetails> createState() => _HomeworkHistoryDetailsState();
}

class _HomeworkHistoryDetailsState extends State<HomeworkHistoryDetails> {
  final CreateHomeworkController controller = Get.put(
    CreateHomeworkController(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getHomeWorkDetails(classId: widget.homeworkId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          final details = controller.homeworkDetails.value;

          if (details == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Pick first image from tasks (cover)
          final tasks = details.tasks ?? [];

          // Get first image task
          Map<String, dynamic>? firstImageTask;
          for (var t in tasks) {
            if (t['type'] == 'image') {
              firstImageTask = t;
              break;
            }
          }

          // Remaining tasks, excluding the first image
          final remainingTasks =
              tasks.where((t) => t != firstImageTask).toList();

          // Separate remaining images and paragraphs
          final remainingImages =
              remainingTasks.where((t) => t['type'] == 'image').toList();
          final remainingParagraphs =
              remainingTasks.where((t) => t['type'] == 'paragraph').toList();
          final remainingLists =
              remainingTasks.where((t) => t['type'] == 'list').toList();

          return SingleChildScrollView(
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
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- First image ---
                          if (firstImageTask != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                firstImageTask['content'] ?? '',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                      AppImages.homeworkPreviewImage2,
                                    ),
                              ),
                            )
                          else
                            Image.asset(
                              AppImages.homeworkPreviewImage2,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                          const SizedBox(height: 20),

                          // --- Title & main description ---
                          Text(
                            details.title ?? '',
                            style: GoogleFont.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: AppColor.lightBlack,
                            ),
                          ),
                          if (details.description != null)
                            Text(
                              details.description,
                              style: GoogleFont.inter(
                                fontSize: 12,
                                color: AppColor.gray,
                              ),
                            ),
                          if (remainingLists.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              "List Points:",
                              style: GoogleFont.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(remainingLists.length, (
                                  index,
                                  ) {
                                final task = remainingLists[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    "${index + 1}. ${task['content'] ?? ''}",
                                    style: GoogleFont.inter(
                                      fontSize: 13,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                          const SizedBox(height: 16),

                          // --- Remaining images ---
                          ...remainingImages.map<Widget>(
                            (task) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  task['content'] ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                            AppImages.homeworkPreviewImage2,
                                          ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // --- Paragraphs ---
                          ...remainingParagraphs.map<Widget>(
                            (task) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                task['content'] ?? '',
                                style: GoogleFont.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColor.gray,
                                ),
                              ),
                            ),
                          ),
                          // --- List Points ---


                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                                            child: Image.asset(
                                              AppImages.avatar1,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            '${details?.subject.name}',
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
                                            details?.time ?? '',
                                            style: GoogleFont.inter(
                                              fontSize: 12,
                                              color: AppColor.lightBlack,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            details?.date ?? '',
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
}
