import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/date_and_time_convert.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'controller/create_homework_controller.dart';

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

  // ---------- Image helpers (network) ----------
  void _openFullScreenNetwork(String url) {
    if (url.isEmpty) return;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder:
          (_) => GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 5,
                child: Image.network(
                  url,
                  errorBuilder:
                      (_, __, ___) =>
                          Image.asset(AppImages.homeworkPreviewImage2),
                ),
              ),
            ),
          ),
    );
  }

  /// Full-width network image with large height, keeps aspect (no crop).
  Widget _fullWidthNetImage(String url) {
    final h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => _openFullScreenNetwork(url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: h * 0.6), // big but safe
          child: Image.network(
            url,
            width: double.infinity,
            fit:
                BoxFit
                    .contain, // change to cover if you prefer edge-to-edge crop
            errorBuilder:
                (_, __, ___) => Image.asset(
                  AppImages.homeworkPreviewImage2,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
          ),
        ),
      ),
    );
  }

  /// Preview (short) + onTap full-screen
  Widget _shortPreviewNetImage(String url) {
    return GestureDetector(
      onTap: () => _openFullScreenNetwork(url), // full screen on tap
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 200, // 👈 short preview fixed height
          width: double.infinity,
          color: Colors.grey[200],
          child: Image.network(
            url,
            fit: BoxFit.cover, // 👈 cover makes it look neat
            errorBuilder: (_, __, ___) => Image.asset(
              AppImages.homeworkPreviewImage2,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
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

          final List<dynamic> tasks = (details.tasks ?? []);
          Map<String, dynamic>? firstImageTask;
          for (final t in tasks) {
            if (t is Map &&
                t['type'] == 'image' &&
                (t['content'] ?? '').toString().isNotEmpty) {
              firstImageTask = t.cast<String, dynamic>();
              break;
            }
          }

          final remainingTasks =
              tasks.where((t) => t != firstImageTask).toList();
          final remainingImages =
              remainingTasks
                  .where((t) => t is Map && t['type'] == 'image')
                  .cast<Map>()
                  .toList();
          final remainingParagraphs =
              remainingTasks
                  .where((t) => t is Map && t['type'] == 'paragraph')
                  .cast<Map>()
                  .toList();
          final remainingLists =
              remainingTasks
                  .where((t) => t is Map && t['type'] == 'list')
                  .cast<Map>()
                  .toList();

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
                      'Homework Details',
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 30,
                            left: 30,
                            top: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ---- First image (full width) ----
                              // if (firstImageTask != null)
                              //   _fullWidthNetImage((firstImageTask!['content'] ?? '').toString())
                              // else
                              //   ClipRRect(
                              //     borderRadius: BorderRadius.circular(16),
                              //     child: Image.asset(
                              //       AppImages.homeworkPreviewImage2,
                              //       width: double.infinity,
                              //       fit: BoxFit.contain,
                              //     ),
                              //   ),

                              // ---- Remaining images (each full width) ----
                              ...remainingImages.map<Widget>((task) {
                                final url = (task['content'] ?? '').toString();
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _shortPreviewNetImage(url), // 👈 now short preview + full screen
                                );
                              }),


                              const SizedBox(height: 16),

                              // ---- Title & main description ----
                              Text(
                                (details.title ?? ''),
                                style: GoogleFont.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: AppColor.lightBlack,
                                ),
                              ),
                              if ((details.description ?? '')
                                  .toString()
                                  .trim()
                                  .isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  (details.description ?? '').toString(),
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    color: AppColor.gray,
                                  ),
                                ),
                              ],

                              // ---- List points (if any) ----
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
                                        "${index + 1}. ${(task['content'] ?? '').toString()}",
                                        style: GoogleFont.inter(
                                          fontSize: 13,
                                          color: AppColor.gray,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],

                              const SizedBox(height: 12),

                              // ---- Paragraphs ----
                              ...remainingParagraphs.map<Widget>((task) {
                                final txt = (task['content'] ?? '').toString();
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    txt,
                                    style: GoogleFont.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: AppColor.gray,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        // ---- Subject / Time chips ----
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 30,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.black.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 20,
                                    ),
                                    child: Row(
                                      children: [
                                        // CircleAvatar(
                                        //   child: Image.asset(AppImages.avatar1),
                                        // ),
                                        // const SizedBox(width: 10),
                                        Text(
                                          (details.subject?.name ?? '')
                                              .toString(),
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.lightBlack,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
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
                                        const SizedBox(width: 10),
                                        Text(
                                          DateAndTimeConvert.formatDateTime(
                                            showTime: true,
                                            showDate: false,
                                            details.time.toString(),
                                          ),
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.black,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          DateAndTimeConvert.formatDateTime(
                                            showTime: false,
                                            showDate: true,
                                            details.date.toString(),
                                          ),
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
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
