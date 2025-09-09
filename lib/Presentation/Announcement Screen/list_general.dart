import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:st_teacher_app/Core/Widgets/common_container.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/custom_textfield.dart';
import '../../Core/Utility/google_fonts.dart';
import '../Attendance/controller/attendance_controller.dart';
import 'announcement_create.dart';

class ListGeneral extends StatefulWidget {

  const ListGeneral({
    super.key,

  });

  @override
  State<ListGeneral> createState() => _ListGeneralState();
}

class _ListGeneralState extends State<ListGeneral> {
  int selectedIndex = 0;
  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );

  final List<Map<String, String>> subjects = const [
    {'subject': 'Tamil', 'mark': '70'},
    {'subject': 'English', 'mark': '70'},
    {'subject': 'Maths', 'mark': '70'},
    {'subject': 'Science', 'mark': '70'},
    {'subject': 'Social Science', 'mark': '70'},
  ];

  // ---------------------- Bottom Sheets ----------------------

  void _feesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.20,
          maxChildSize: 0.55,
          expand: false,
          builder: (context, scrollController) {
            final items = ['Shoes', 'Notebooks', 'Tuition Fees'];

            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColor.borderGary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(AppImages.announcement2),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Third-Term Fees',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Due date',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 12,
                              color: AppColor.lightgray,
                            ),
                          ),
                          Text(
                            '12-Dec-25',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        CupertinoIcons.clock_fill,
                        size: 30,
                        color: AppColor.borderGary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      items.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '${index + 1}. ${items[index]}',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 16,
                            color: AppColor.lightBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColor.blueG1, AppColor.blue],
                          begin: Alignment.topRight,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pay Rs.15,000',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColor.white,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              CupertinoIcons.right_chevron,
                              size: 14,
                              color: AppColor.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _examResult(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.20,
          maxChildSize: 0.65,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColor.borderGary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Third term fees Result',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightBlack,
                        ),
                      ),
                      const SizedBox(height: 7),
                      RichText(
                        text: TextSpan(
                          text: 'A+',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 43,
                            fontWeight: FontWeight.w600,
                            color: AppColor.green,
                          ),
                          children: [
                            TextSpan(
                              text: ' Grade',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 43,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: DottedLine(
                          dashColor: AppColor.borderGary,
                          dashGapLength: 6,
                          dashLength: 7,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Marks list
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              AppImages.examResultBCImage,
                              height: 100,
                              width: 180,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: subjects.length,
                            itemBuilder: (context, index) {
                              final subject = subjects[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 38.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        subject['subject']!,
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.gray,
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      Text(
                                        subject['mark']!,
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: DottedLine(
                          dashColor: AppColor.borderGary,
                          dashGapLength: 6,
                          dashLength: 7,
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 30,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColor.blue,
                                width: 1,
                              ),
                            ),
                            child: CustomTextField.textWithSmall(
                              text: 'Close',
                              color: AppColor.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------- Tabs Content ----------------------

  Widget _buildGeneralTab(BuildContext context) {
    return Column(
      children: [
        CommonContainer.announcementsScreen(
          mainText: 'Today Special',
          backRoundImage: AppImages.announcement1,
          additionalText1: '',
          additionalText2: '',
          verticalPadding: 12,
          gradientStartColor: AppColor.black.withOpacity(0.1),
          gradientEndColor: AppColor.black,
        ),
        const SizedBox(height: 20),
        CommonContainer.announcementsScreen(
          mainText: 'Third-Term Fees',
          backRoundImage: AppImages.announcement2,
          iconData: CupertinoIcons.clock_fill,
          additionalText1: 'Due date',
          additionalText2: '12-Dec-25',
          verticalPadding: 6,
          gradientStartColor: AppColor.black.withOpacity(0.1),
          gradientEndColor: AppColor.black,
          onDetailsTap: () => _feesSheet(context),
        ),
        const SizedBox(height: 20),
        CommonContainer.announcementsScreen(
          mainText: 'Result- First Term',
          backRoundImage: AppImages.announcement6,
          iconData: CupertinoIcons.clock_fill,
          additionalText1: '',
          additionalText2: '18-Jun-25',
          verticalPadding: 12,
          gradientStartColor: AppColor.black.withOpacity(0.01),
          gradientEndColor: AppColor.black,
          onDetailsTap: () => _examResult(context),
        ),
        const SizedBox(height: 20),
        CommonContainer.announcementsScreen(
          mainText: 'Heavy Rain Holiday',
          backRoundImage: AppImages.announcement7,
          iconData: CupertinoIcons.clock_fill,
          additionalText1: '',
          additionalText2: '11-Jun-25',
          verticalPadding: 12,
          gradientStartColor: AppColor.black.withOpacity(0.01),
          gradientEndColor: AppColor.black,
        ),
        const SizedBox(height: 20),
        CommonContainer.announcementsScreen(
          mainText: 'Sports Day',
          backRoundImage: AppImages.announcement3,
          iconData: CupertinoIcons.clock_fill,
          additionalText1: '',
          additionalText2: '18-Jun-25',
          verticalPadding: 12,
          gradientStartColor: AppColor.black.withOpacity(0.1),
          gradientEndColor: AppColor.black,
        ),
        const SizedBox(height: 20),
        CommonContainer.announcementsScreen(
          mainText: 'Parents Meeting',
          backRoundImage: AppImages.announcement4,
          iconData: CupertinoIcons.clock_fill,
          additionalText1: '',
          additionalText2: '20-Jun-25',
          verticalPadding: 15,
          gradientStartColor: AppColor.black.withOpacity(0.01),
          gradientEndColor: AppColor.black,
        ),
        const SizedBox(height: 20),
        CommonContainer.announcementsScreen(
          mainText: 'Mid-Term Exam',
          backRoundImage: AppImages.announcement5,
          iconData: CupertinoIcons.clock_fill,
          additionalText1: 'Starts on',
          additionalText2: '20-Jun-25',
          verticalPadding: 1,
          gradientStartColor: AppColor.black.withOpacity(0.05),
          gradientEndColor: AppColor.black,
        ),
      ],
    );
  }

  Widget _buildTeacherTab(BuildContext context) {
    return Column(
      children: [
        CommonContainer.announcementsScreen(
          mainText: 'Teachers Meeting',
          backRoundImage: AppImages.announcement8,
          iconData: CupertinoIcons.clock_fill,
          additionalText1: 'On',
          additionalText2: '20-Jun-25',
          verticalPadding: 10,
          gradientStartColor: AppColor.black.withOpacity(0.08),
          gradientEndColor: AppColor.black,
        ),
        const SizedBox(height: 20),
        CommonContainer.announcementsScreen(
          mainText: 'Exam Paper Submission',
          backRoundImage: AppImages.announcement5,
          iconData: CupertinoIcons.clock_fill,
          additionalText1: 'Deadline',
          additionalText2: '30-Jun-25',
          verticalPadding: 10,
          gradientStartColor: AppColor.black.withOpacity(0.08),
          gradientEndColor: AppColor.black,
        ),
      ],
    );
  }

  // ---------------------- UI ----------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
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
                    const Spacer(),
                    // Quick link to create (still available here if you like)
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AnnouncementCreate(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Create Homework',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColor.blue,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Image.asset(AppImages.doubleArrow, height: 19),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Center(
                  child: Text(
                    selectedIndex == 0 ? 'Announcements' : 'Announcements',
                    style: GoogleFont.ibmPlexSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // BODY CHANGES BY TAB
                if (selectedIndex == 0)
                  _buildGeneralTab(context)
                else
                  _buildTeacherTab(context),
              ],
            ),
          ),
        ),
      ),

      // Bottom tab chips
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: AppColor.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: CommonContainer.statusChips(
            horizontalPadding: 60,
            tabs: [
              {"label": "General"},
              {"label": "Teacher"},
            ],
            selectedIndex: selectedIndex,
            onSelect: (i) => setState(() => selectedIndex = i),
          ),
        ),
      ),
    );
  }
}
