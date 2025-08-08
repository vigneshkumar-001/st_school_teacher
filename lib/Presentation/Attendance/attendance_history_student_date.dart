import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/Utility/google_fonts.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Widgets/common_container.dart';
import 'attendance_history_student.dart';

class AttendanceHistoryStudentDate extends StatefulWidget {
  final DateTime selectedDate;
  const AttendanceHistoryStudentDate({super.key, required this.selectedDate});

  @override
  State<AttendanceHistoryStudentDate> createState() =>
      _AttendanceHistoryStudentDateState();
}

class _AttendanceHistoryStudentDateState
    extends State<AttendanceHistoryStudentDate> {
  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();

    selectedMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );
  }

  void goToPreviousMonth() {
    setState(() {
      selectedMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month - 1,
        selectedMonth.day,
      );
    });
  }

  void goToNextMonth() {
    setState(() {
      selectedMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + 1,
        selectedMonth.day,
      );
    });
  }

  int current = 15;
  int total = 20;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetProgress = current / total;
    final progressWidth = screenWidth * targetProgress;
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Padding(
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
                child: RichText(
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
              ),
              SizedBox(height: 3),
              Center(
                child: Text(
                  'Juliana Attendance',
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
                            onPressed: goToPreviousMonth,
                          ),
                          Spacer(),
                          Text(
                            DateFormat('dd MMMM').format(selectedMonth),
                            style: GoogleFont.ibmPlexSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(CupertinoIcons.right_chevron),
                            onPressed: goToNextMonth,
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
                              Image.asset(AppImages.morning, height: 53),
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
                                            AppColor.lightgray.withOpacity(0.1),
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
                              Image.asset(AppImages.afternoon, height: 53),
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
                      SizedBox(height: 20),
                      CommonContainer.announcementsScreen(
                        additionalText2: '3Pm ',
                        additionalText3: 'to ',
                        additionalText4: '5Pm',
                        mainText: 'Sports Day',
                        backRoundImage: AppImages.sportsDay,
                        iconData: CupertinoIcons.clock_fill,
                        additionalText1: '',

                        verticalPadding: 12,
                        gradientStartColor: AppColor.black.withOpacity(0.1),
                        gradientEndColor: AppColor.black,
                      ),
                      SizedBox(height: 38),
                      Row(
                        children: [
                          Text(
                            'July Overall Attendance ',
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

                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.lightgray,
                                  AppColor.lowLightgray.withOpacity(0.2),
                                  AppColor.lowLightgray.withOpacity(0.2),
                                  AppColor.lightgray,
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.black.withOpacity(0.1),
                                  blurRadius: 9,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: 30,
                            width: progressWidth,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColor.averageG3Red,
                                  AppColor.averageG2Yellow,
                                  AppColor.averageG1Green,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),

                          Positioned(
                            left: progressWidth - 25,
                            top: 3,
                            child: Container(
                              width: 12,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      Text(
                        "$current Out of $total",
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
                        builder: (context) => AttendanceHistoryStudent(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColor.lightgray, width: 1),
                    padding: EdgeInsets.symmetric(horizontal: 45, vertical: 16),
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
        ),
      ),
    );
  }
}
