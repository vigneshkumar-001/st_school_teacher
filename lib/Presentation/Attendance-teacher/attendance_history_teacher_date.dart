import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Presentation/Attendance-teacher/controller/teacher_attendance_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Utility/progress_bar.dart';
import '../../Core/Widgets/attendance_card.dart';
import '../../Core/Widgets/common_container.dart';
import 'attendance_history_teacher.dart';
import 'package:get/get.dart';

import 'model/teacher_daily_attendance_response.dart';

class AttendanceHistoryTeacherDate extends StatefulWidget {
  final DateTime selectedDate;
  final String teacherName;
  const AttendanceHistoryTeacherDate({
    super.key,
    required this.selectedDate,
    required this.teacherName,
  });

  @override
  State<AttendanceHistoryTeacherDate> createState() =>
      _AttendanceHistoryTeacherDateState();
}

class _AttendanceHistoryTeacherDateState
    extends State<AttendanceHistoryTeacherDate> {
  DateTime selectedMonth = DateTime.now();
  late DateTime selectedDate;
  bool isLoading = true;
  TeacherDailyAttendanceData? teacherDailyAttendanceData;
  final TeacherAttendanceController controller = Get.put(
    TeacherAttendanceController(),
  );
  @override
  void initState() {
    super.initState();

    selectedDate = widget.selectedDate;

    selectedMonth = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAttendance(); // ✅ run after build
    });
  }

  void goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
    });
    _fetchAttendance();
  }

  void goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
    });
    _fetchAttendance();
  }

  int current = 15;
  int total = 20;
  void _fetchAttendance() async {
    setState(() {
      isLoading = true;
    });

    final result = await controller.getTeacherDailyAttendance(
      date: selectedDate,

      showLoader: true,
    );

    if (result != null) {
      setState(() {
        teacherDailyAttendanceData = result;
        current =
            ((teacherDailyAttendanceData?.thisMonthPresentPercentage ?? 0) *
                    total ~/
                    100)
                .toInt();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false; // still stop loading even if no result
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetProgress = current / total;
    final progressWidth = screenWidth * targetProgress;
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(() {
          final data = controller.teacherDailyAttendanceData.value;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonContainer.NavigatArrow(
                  image: AppImages.leftSideArrow,
                  onIconTap: () => Navigator.pop(context),
                  container: AppColor.white,
                  border: Border.all(color: AppColor.lightgray, width: 0.3),
                ),
                SizedBox(height: 18),

                Center(
                  child: Text(
                    widget.teacherName,
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(CupertinoIcons.left_chevron),
                              onPressed: goToPreviousDay,
                            ),
                            Spacer(),
                            Text(
                              DateFormat('dd MMMM').format(selectedDate),
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(CupertinoIcons.right_chevron),
                              onPressed: goToNextDay,
                            ),
                          ],
                        ),
                        SizedBox(height: 38),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColor.lowLightgray),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CurvedAttendanceCard(
                                  imagePath: AppImages.morning,
                                  isAbsent:
                                      data?.morning ==
                                      "present",
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Morning',
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppColor.black,
                                  ),
                                ),
                                SizedBox(width: 22),
                                SizedBox(
                                  height: 70,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(8, (index) {
                                      return Container(
                                        width: 2,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColor.lightgray.withOpacity(
                                                0.1,
                                              ),
                                              AppColor.white.withOpacity(0.4),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                SizedBox(width: 22),
                                CurvedAttendanceCard(
                                  imagePath: AppImages.afternoon,
                                  isAbsent:
                                      data?.afternoon ==
                                      "present",
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Afternoon',
                                  style: GoogleFont.ibmPlexSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppColor.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(height: 20),
                        // CommonContainer.announcementsScreen(
                        //   additionalText2: '3Pm ',
                        //   additionalText3: 'to ',
                        //   additionalText4: '5Pm',
                        //   mainText: 'Sports Day',
                        //   backRoundImage: AppImages.sportsDay,
                        //   iconData: CupertinoIcons.clock_fill,
                        //   additionalText1: '',
                        //
                        //   verticalPadding: 12,
                        //   gradientStartColor: AppColor.black.withOpacity(0.1),
                        //   gradientEndColor: AppColor.black,
                        // ),
                        SizedBox(height: 38),
                        Row(
                          children: [
                            Text(
                              '${ data?.monthName ?? ''} Overall Attendance ',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),

                            Spacer(),
                            Text(
                              'Average',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.orange,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),


                        GradientProgressBar(
                          progress:
                              (data
                                      ?.thisMonthPresentPercentage ??
                                  0) /
                              100,
                        ),

                        SizedBox(height: 15),

                        Text(
                          "${data?.fullDayPresentCount} Out of ${data?.totalWorkingDays}",
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 27),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceHistoryTeacher(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.lightgray, width: 1),
                      padding: EdgeInsets.symmetric(
                        horizontal: 45,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AppImages.leftSideArrow, height: 14),
                        SizedBox(width: 12),
                        Text(
                          'Back to Calendar',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColor.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
