import 'package:flutter/material.dart';
import 'package:st_teacher_app/Presentation/Home/controller/message_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/date_and_time_convert.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'package:get/get.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageController controller = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: AppLoader.circularLoader());
          }

          final grouped = controller.groupedMessages;

          if (grouped.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 80),
              decoration: BoxDecoration(color: AppColor.white),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'No message available',
                      style: GoogleFont.ibmPlexSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColor.gray,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Image.asset(AppImages.noDataFound),
                ],
              ),
            );
          }

          List<Color> colors = [
            AppColor.lightBlueC1,
            AppColor.lowLightYellow,
            AppColor.lowLightNavi,
            AppColor.lowLightPink,
          ];

          final groups = grouped.entries.toList();

          return RefreshIndicator(
            onRefresh: () async {
              await controller.getMessageList();
            },
            child: ListView.builder(
              itemCount: groups.length + 1, // +1 for back button row
              itemBuilder: (context, groupIndex) {
                if (groupIndex == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 18,
                    ),
                    child: Row(
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
                      ],
                    ),
                  );
                }

                final group = groups[groupIndex - 1];
                final groupTitle = group.key;
                final messages = group.value;

                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.getMessageList();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              groupTitle,
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.gray,
                              ),
                            ),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListView.builder(
                            itemCount: messages.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final msg = messages[index];

                              return Obx(() {
                                final isLoading = controller.loadingMessages
                                    .contains(msg.id);
                                return CommonContainer.homeworkhistory(
                                  rightSideArrow: false,
                                  onIconTapLike: () async {
                                    await controller.reactForStudentMessage(
                                      msgId: msg.id,
                                      like: !(msg.reacted ?? false),
                                    );
                                  },
                                  homeWorkText: msg.student.name,
                                  likeImage: !(msg.reacted ?? false),
                                  isLikeLoading: isLoading,
                                  avatarImage: '',
                                  mainText: msg.text,
                                  smaleText: '',
                                  time:
                                      DateAndTimeConvert.formatDateTime(
                                        msg.createdAt.toIso8601String(),
                                        showTime: true,
                                        showDate: false,
                                      ) ??
                                      "-",
                                  className: msg.studentClass.name,
                                  aText1: '',
                                  aText2: '',
                                  CText1:
                                      "${msg.studentClass.name} ${msg.studentClass.section}",
                                  backRoundColor: colors[index % colors.length],
                                  section: msg.studentClass.section,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          child: SingleChildScrollView(
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
                    'Today Messages',
                    style: GoogleFont.inter(
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
                  child: Column(
                    children: [
                      CommonContainer.homeworkhistory(
                        onIconTapLike: () {},
                        homeWorkText: 'S. Pragadheeswari ',
                        likeImage: true,
                        avatarImage: '',
                        mainText:
                            'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                        smaleText: '',
                        time: 'time',
                        className: 'className',
                        aText1: '',
                        aText2: '',
                        CText1: '7th C',
                        backRoundColor: AppColor.lightBlueC1,
                        section: 'section',
                      ),
                      SizedBox(height: 15),
                      CommonContainer.homeworkhistory(
                        onIconTapLike: () {},
                        homeWorkText: 'S. Pragadheeswari ',
                        likeImage: true,
                        avatarImage: '',
                        mainText:
                            'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                        smaleText: '',
                        time: 'time',
                        className: 'className',
                        aText1: '',
                        aText2: '',
                        CText1: '7th C',
                        backRoundColor: AppColor.lightBlueC1,
                        section: 'section',
                      ),
                      SizedBox(height: 15),
                      CommonContainer.homeworkhistory(
                        onIconTapLike: () {},
                        homeWorkText: 'S. Pragadheeswari ',
                        likeImage: true,
                        avatarImage: '',
                        mainText:
                            'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                        smaleText: '',
                        time: 'time',
                        className: 'className',
                        aText1: '',
                        aText2: '',
                        CText1: '7th C',
                        backRoundColor: AppColor.lowLightYellow,
                        section: 'section',
                      ),
                      SizedBox(height: 15),
                      CommonContainer.homeworkhistory(
                        onIconTapLike: () {},
                        homeWorkText: 'S. Pragadheeswari ',
                        likeImage: true,
                        avatarImage: '',
                        mainText:
                            'Praghadheeswari has fever from yesterday night, i gives the tablet to her, please ensure she will eat the table',
                        smaleText: '',
                        time: 'time',
                        className: 'className',
                        aText1: '',
                        aText2: '',
                        CText1: '7th C',
                        backRoundColor: AppColor.lowLightNavi,
                        section: 'section',
                      ),
                      SizedBox(height: 15),
                    ],
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
