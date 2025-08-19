import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:st_teacher_app/Presentation/Homework/controller/create_homework_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_app_button.dart';
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(AppImages.homeworkPreviewImage1),
                                SizedBox(height: 20),
                                Image.asset(AppImages.homeworkPreviewImage2),
                                SizedBox(height: 20),
                                Text(
                                  details?.title ?? '',
                                  style: GoogleFont.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: AppColor.lightBlack,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  details?.description ?? '',
                                  style: GoogleFont.inter(
                                    fontSize: 12,
                                    color: AppColor.gray,
                                  ),
                                ),
                                SizedBox(height: 15),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                      details?.tasks.length ?? 0,
                                          (index) {
                                        final task = details!.tasks[index];
                                        final content = task['content'] ?? '';
                                        return Text(
                                          '${index + 1}. $content',
                                          style: GoogleFont.inter(
                                            fontSize: 12,
                                            color: AppColor.gray,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
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