import 'package:flutter/material.dart';
import 'package:st_teacher_app/Presentation/Attendance/controller/attendance_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';

class AttendanceStart extends StatefulWidget {
  const AttendanceStart({super.key});

  @override
  State<AttendanceStart> createState() => _AttendanceStartState();
}

class _AttendanceStartState extends State<AttendanceStart> {
  int selectedIndex = 0;

  final AttendanceController attendanceController = AttendanceController();


  int subjectIndex = 0;

  final List<Map<String, dynamic>> tab = [
    {"label": "7th C"},
    {"label": "11th C1"},
  ];


  final List<Map<String, dynamic>> tabs = [
    {"count": 10, "label": "Present"},
    {"count": 5, "label": "Absent"},
    {"count": 3, "label": "Pending"},
  ];

  @override
  void initState() {
    super.initState();
    attendanceController.getClassList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),
                child: Column(
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
                    SizedBox(height: 40),
                    RichText(
                      text: TextSpan(
                        text: '7',
                        style: GoogleFont.ibmPlexSans(
                          fontSize: 14,
                          color: AppColor.gray,
                          fontWeight: FontWeight.w800,
                        ),
                        children: [
                          TextSpan(
                            text: 'th ',
                            style: GoogleFont.ibmPlexSans(fontSize: 10),
                          ),
                          TextSpan(
                            text: 'C ',
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 14,
                              color: AppColor.gray,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: 'Section',
                            style: GoogleFont.ibmPlexSans(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Afternoon Attendance',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    'Later',
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Anjana',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 20,
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.red,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 13,
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              AppImages.close,
                                              height: 20.86,
                                              color: AppColor.white,
                                            ),
                                            SizedBox(width: 7),
                                            Text(
                                              'Absent',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.green,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 13,
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              AppImages.tick,
                                              height: 19.62,
                                              color: AppColor.white,
                                            ),
                                            SizedBox(width: 7),
                                            Text(
                                              'Present',
                                              style: GoogleFont.ibmPlexSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Students List',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: List.generate(tabs.length, (index) {
                                final isSelected = selectedIndex == index;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6.5,
                                  ),
                                  child: GestureDetector(
                                    onTap:
                                        () => setState(
                                          () => selectedIndex = index,
                                        ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.5,
                                        vertical: 9,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? AppColor.white
                                                : AppColor.lowLightgray,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? AppColor.blue
                                                  : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        "${tabs[index]['count']} ${tabs[index]['label']}",
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 12,
                                          color:
                                              isSelected
                                                  ? AppColor.blue
                                                  : AppColor.gray,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 10),
                            if (selectedIndex == 0) ...[
                              CommonContainer.StudentsList(
                                mainText: 'Kanjana',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Olivia',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Juliya',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Marie',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Christiana',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Olivia',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Stella',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Marie',
                                onIconTap: () {},
                              ),
                            ] else if (selectedIndex == 1) ...[
                              CommonContainer.StudentsList(
                                mainText: 'Marie',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Christiana',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Olivia',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Stella',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Marie',
                                onIconTap: () {},
                              ),
                            ] else if (selectedIndex == 2) ...[
                              CommonContainer.StudentsList(
                                mainText: 'Olivia',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Stella',
                                onIconTap: () {},
                              ),
                              CommonContainer.StudentsList(
                                mainText: 'Marie',
                                onIconTap: () {},
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 34),
              Container(
                decoration: BoxDecoration(color: AppColor.white),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Row(
                        children: List.generate(tab.length, (index) {
                          final isSelected = subjectIndex == index;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () => setState(() => subjectIndex = index),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSelected ? 55 : 55,
                                  vertical: isSelected ? 9 : 9,
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

                                  child: Text(
                                    "${tabs[index]['count']} ${tabs[index]['label']}",
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 12,
                                      color:
                                          isSelected
                                              ? AppColor.blue
                                              : AppColor.gray,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w400,

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
                                    SizedBox(width: isSelected ? 5 : 0),
                                    Text(
                                      " ${tab[index]['label']}",
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
