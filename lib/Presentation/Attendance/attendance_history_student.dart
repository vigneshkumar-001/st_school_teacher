import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_student_history.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Utility/progress_bar.dart';
import '../../Core/Widgets/common_container.dart';
import 'attendance_history.dart';
import 'attendance_history_student_date.dart';
import 'controller/attendance_controller.dart';
import 'controller/attendance_student_controller.dart';
import 'package:get/get.dart';

class AttendanceHistoryStudent extends StatefulWidget {
  final int? studentId;
  final int? classId;
  const AttendanceHistoryStudent({super.key, this.studentId, this.classId});

  @override
  State<AttendanceHistoryStudent> createState() =>
      _AttendanceHistoryStudentState();
}

class _AttendanceHistoryStudentState extends State<AttendanceHistoryStudent> {
  DateTime today = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  AttendanceStudentData? attendanceData;
  DateTime selectedDay = DateTime.now();
  final AttendanceStudentController attendanceHistoryController = Get.put(
    AttendanceStudentController(),
  );

  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );
  var selectedClass;

  int current = 15;
  int total = 20;
  @override
  /*void initState() {
    super.initState();
    loadStudentAttendance(_focusedDay);

    attendanceController.getClassList().then((_) async {
      if (attendanceController.classList.isNotEmpty) {
        selectedClass = attendanceController.classList.first;

        final attendanceData = await attendanceController.getTodayStatus(
          selectedClass.id,
        );

        setState(() {});
      }
    });
    loadStudentAttendance(_focusedDay);
  }*/

  @override
  void initState() {
    super.initState();

    // Load local data (safe)
    loadStudentAttendance(_focusedDay);

    // Delay reactive updates until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await attendanceController.getClassList();
      if (attendanceController.classList.isNotEmpty) {
        selectedClass = attendanceController.classList.first;

        final attendanceData = await attendanceController.getTodayStatus(
          selectedClass.id,
        );

        setState(() {}); // safe now
      }
    });
  }


  Color? getAttendanceColor(
    DateTime day,
    Map<String, AttendanceByDate> attendanceByDate,
  ) {
    String formatted = DateFormat('yyyy-MM-dd').format(day);
    if (!attendanceByDate.containsKey(formatted)) return null;

    final dayData = attendanceByDate[formatted]!;

    if (dayData.fullDayAbsent) {
      return AppColor.red;
    } else if (dayData.holidayStatus) {
      return AppColor.green;
    } else if (dayData.eventsStatus) {
      return AppColor.yellow;
    }

    return null;
  }

  void loadStudentAttendance(DateTime focusedDay) async {
    final response = await attendanceHistoryController
        .fetchStudentAttendanceHistory(
          studentId: widget.studentId ?? 0,
          classId: widget.classId ?? 0,
          date: focusedDay,
          showLoader: false,
        );

    if (response != null) {
      setState(() {
        attendanceData = response;
      });
    } else {
      print("Failed to fetch attendance data");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: RichText(
                    text: TextSpan(
                      text: selectedClass?.className ?? '',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 14,
                        color: AppColor.gray,
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${selectedClass?.section ?? ''}',
                          style: GoogleFont.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.gray,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: ' Section',
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
                    '${attendanceData?.studentName ?? "Loading..."} Attendance',
                    style: GoogleFonts.ibmPlexSans(
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
                            focusedDay: _focusedDay,
                            firstDay: DateTime.utc(2000),
                            lastDay: DateTime.utc(2050),
                            onPageChanged: (focusedDay) {
                              setState(() {
                                _focusedDay = focusedDay;
                              });
                              loadStudentAttendance(focusedDay);
                            },
                            selectedDayPredicate:
                                (day) => isSameDay(day, _selectedDay),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AttendanceHistoryStudentDate(
                                        selectedDate: _selectedDay!,
                                        studentId: widget.studentId ?? 0,
                                        classId: selectedClass.id,
                                        studentName:
                                            attendanceData?.studentName,
                                        className:
                                            selectedClass?.className ?? '',
                                        section: selectedClass?.section ?? '',
                                      ),
                                ),
                              );
                            },
                            calendarStyle: CalendarStyle(
                              markersMaxCount: 1,
                              markerSize: 6,
                            ),
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, day, events) {
                                final color = getAttendanceColor(
                                  day,
                                  attendanceData?.attendanceByDate ?? {},
                                );
                                if (color != null) {
                                  return Positioned(
                                    bottom: 4,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                              defaultBuilder: (context, day, focusedDay) {
                                return Center(
                                  child: Text(
                                    '${day.day}',
                                    style: GoogleFonts.ibmPlexSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

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
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              '${attendanceData?.monthName} Overall Attendance ',
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

                        SizedBox(height: 20),
                        GradientProgressBar(
                          progress:
                              (attendanceData?.presentPercentage ?? 0) / 100,
                        ),

                        SizedBox(height: 15),

                        SizedBox(height: 12),

                        Text(
                          "${attendanceData?.fullDayPresentCount ?? '0'} Out of ${attendanceData?.totalWorkingDays ?? '0'}",
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
                      HapticFeedback.heavyImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceHistory(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.lightgray, width: 1),
                      padding: EdgeInsets.symmetric(
                        horizontal: 60,
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
                          'Back to Common History',
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
      ),
    );
  }
}
