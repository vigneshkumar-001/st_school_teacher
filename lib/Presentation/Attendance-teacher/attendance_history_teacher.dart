import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'attendance_history_teacher_date.dart';

class AttendanceHistoryTeacher extends StatefulWidget {
  const AttendanceHistoryTeacher({super.key});

  @override
  State<AttendanceHistoryTeacher> createState() =>
      _AttendanceHistoryTeacherState();
}

class _AttendanceHistoryTeacherState extends State<AttendanceHistoryTeacher> {
  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceHistoryTeacherDate(selectedDate: day),
      ),
    );
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          child: SingleChildScrollView(
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
                    'Juliana Attendance ',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                ),
                SizedBox(height: 21),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: TableCalendar(
                            focusedDay: today,
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: GoogleFont.ibmPlexSans(
                                color: AppColor.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                              leftChevronIcon: Icon(
                                CupertinoIcons.left_chevron,
                                size: 24,
                                color: AppColor.gray,
                              ),
                              rightChevronIcon: Icon(
                                CupertinoIcons.right_chevron,
                                size: 24,
                                color: AppColor.gray,
                              ),
                              headerPadding: EdgeInsets.only(bottom: 25),
                            ),
                            availableGestures: AvailableGestures.all,
                            selectedDayPredicate:
                                (day) => isSameDay(day, today),
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            firstDay: DateTime.utc(2000),
                            lastDay: DateTime.utc(2050),
                            onDaySelected: _onDaySelected,
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColor.blue, AppColor.blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              weekendTextStyle: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.lightgray,
                                letterSpacing: 1.2,
                              ),
                              weekNumberTextStyle: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.gray,
                              ),
                              defaultTextStyle: GoogleFont.ibmPlexSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.gray,
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: GoogleFont.ibmPlexSans(
                                color: AppColor.lightgray,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                              weekendStyle: GoogleFont.ibmPlexSans(
                                color: AppColor.lightgray,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.lowLightgray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 15,
                                        color: AppColor.yellow,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Event',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppColor.gray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 15,
                                        color: AppColor.green,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Holidays',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppColor.gray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 15,
                                        color: AppColor.red,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Absent',
                                        style: GoogleFont.ibmPlexSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppColor.gray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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

                        SizedBox(height: 12),

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
                // Center(
                //   child: OutlinedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => AttendanceHistory(),
                //         ),
                //       );
                //     },
                //     style: OutlinedButton.styleFrom(
                //       side: BorderSide(color: AppColor.lightgray, width: 1),
                //       padding: EdgeInsets.symmetric(
                //         horizontal: 60,
                //         vertical: 16,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(50),
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Image.asset(AppImages.leftSideArrow, height: 14),
                //         SizedBox(width: 12),
                //         Text(
                //           'Back to Common History',
                //           style: GoogleFont.ibmPlexSans(
                //             fontSize: 13,
                //             fontWeight: FontWeight.w500,
                //             color: AppColor.gray,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
