import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/Utility/google_fonts.dart';
import 'package:st_teacher_app/Presentation/Attendance/controller/student_attendence_controller.dart';
import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/progress_bar.dart';
import '../../Core/Widgets/attendance_card.dart';
import '../../Core/Widgets/common_container.dart';
import 'attendance_history_student.dart';
import 'controller/attendance_controller.dart';
import 'model/student_attendance_response.dart';
import 'package:get/get.dart';

class AttendanceHistoryStudentDate extends StatefulWidget {
  final DateTime selectedDate;
  final int studentId;
  final int classId;
  final String? studentName;
  final String? className;
  final String? section;
  const AttendanceHistoryStudentDate({
    super.key,
    required this.selectedDate,
    required this.studentId,
    required this.classId,
    this.studentName,
    this.className,
    this.section,
  });

  @override
  State<AttendanceHistoryStudentDate> createState() =>
      _AttendanceHistoryStudentDateState();
}

/*
class _AttendanceHistoryStudentDateState
    extends State<AttendanceHistoryStudentDate> {
  DateTime selectedMonth = DateTime.now();

  final StudentAttendanceController controller = Get.put(
    StudentAttendanceController(),
  );
  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );
  StudentAttendanceData? attendanceData;
  var selectedClass;
  late DateTime selectedDate;
  bool isLoading = true;

  */
/*  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;

    // Load class list and initial attendance data
    attendanceController.getClassList().then((_) async {
      _fetchAttendance();
      if (attendanceController.classList.isNotEmpty) {
        selectedClass = attendanceController.classList.first;
      }
    });
  }*//*

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;

    // Delay GetX updates until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await attendanceController.getClassList();
      if (attendanceController.classList.isNotEmpty) {
        selectedClass = attendanceController.classList.first;
        _fetchAttendance();
      }
    });
  }

  // void _fetchAttendance() async {
  //   final result = await controller.studentDayAttendance(
  //     studentId: widget.studentId,
  //     classId: widget.classId,
  //     date: selectedDate,
  //   );
  //
  //   if (result != null) {
  //     setState(() {
  //       attendanceData =
  //           result; // Assuming result.data is parsed into StudentAttendanceData
  //       current =
  //           (attendanceData?.thisMonthPresentPercentage ?? 0 * total ~/ 100)
  //               .toInt();
  //     });
  //   }
  // }

  void _fetchAttendance() async {
    setState(() {
      isLoading = true;
    });

    final result = await controller.studentDayAttendance(
      studentId: widget.studentId,
      classId: widget.classId,
      date: selectedDate,

      showLoader: true,
    );

    if (result != null) {
      setState(() {
        attendanceData = result;
        current =
            ((attendanceData?.thisMonthPresentPercentage ?? 0) * total ~/ 100)
                .toInt();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false; // still stop loading even if no result
      });
    }
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
                    text: widget.className ?? '',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 14,
                      color: AppColor.gray,
                      fontWeight: FontWeight.w800,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${widget.section ?? ''}',
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
                  widget.studentName ?? '',
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                isAbsent: attendanceData?.morning == "present",
                              ),
                              SizedBox(width: 5),
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
                              CurvedAttendanceCard(
                                imagePath: AppImages.afternoon,
                                isAbsent:
                                    attendanceData?.afternoon ==
                                    "present", // true/false from API
                              ),
                              SizedBox(width: 5),
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

                      SizedBox(height: 50),
                      if (data?.eventsStatus == true) ...[
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: ((data!.eventImage ?? '').isNotEmpty)
                                    ? Image.network(
                                  data.eventImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[300],
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.broken_image),
                                  ),
                                )
                                    : Container(
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                              // Gradient + title
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.1),
                                          Colors.black,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            (data.eventTitle?.trim().isNotEmpty ?? false)
                                                ? data.eventTitle!
                                                : 'Event',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFont.ibmPlexSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: AppColor.white,
                                            ),
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
                      // SizedBox(height: 38),
                      Row(
                        children: [
                          Text(
                            '${attendanceData?.monthName ?? ''} Overall Attendance ',
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


                      */
/*  Stack(
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
                      ),*//*



                      GradientProgressBar(
                        progress:
                            (attendanceData?.thisMonthPresentPercentage ?? 0) /
                            100,
                      ),

                      SizedBox(height: 15),

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
*/


class _AttendanceHistoryStudentDateState
    extends State<AttendanceHistoryStudentDate> {
  DateTime selectedDate = DateTime.now();

  final StudentAttendanceController controller = Get.put(
    StudentAttendanceController(),
  );
  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );
  StudentAttendanceData? attendanceData;
  var selectedClass;
  bool isLoading = true;

  int current = 15;
  int total = 20;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await attendanceController.getClassList();
      if (attendanceController.classList.isNotEmpty) {
        selectedClass = attendanceController.classList.first;
        _fetchAttendance();
      }
    });
  }

  void _fetchAttendance() async {
    setState(() {
      isLoading = true;
    });

    final result = await controller.studentDayAttendance(
      studentId: widget.studentId,
      classId: widget.classId,
      date: selectedDate,
      showLoader: true,
    );

    if (result != null) {
      setState(() {
        attendanceData = result;
        current =
            ((attendanceData?.thisMonthPresentPercentage ?? 0) * total ~/ 100)
                .toInt();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetProgress = current / total;
    final progressWidth = screenWidth * targetProgress;

    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
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
                      text: widget.className ?? '',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 14,
                        color: AppColor.gray,
                        fontWeight: FontWeight.w800,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${widget.section ?? ''}',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 14,
                            color: AppColor.gray,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: ' Section',
                          style: GoogleFonts.ibmPlexSans(
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
                    widget.studentName ?? '',
                    style: GoogleFonts.ibmPlexSans(
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
                              style: GoogleFonts.ibmPlexSans(
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  isAbsent: attendanceData?.morning == "present",
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Morning',
                                  style: GoogleFonts.ibmPlexSans(
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
                                CurvedAttendanceCard(
                                  imagePath: AppImages.afternoon,
                                  isAbsent: attendanceData?.afternoon == "present",
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Afternoon',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppColor.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
          
                        if (attendanceData?.eventsStatus == true) ...[
                          const SizedBox(height: 20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: (attendanceData?.eventImage?.isNotEmpty ?? false)
                                      ? Image.network(
                                    attendanceData!.eventImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey[300],
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.broken_image),
                                    ),
                                  )
                                      : Container(
                                    color: Colors.grey[300],
                                    alignment: Alignment.center,
                                    child:
                                    const Icon(Icons.image_not_supported),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 18,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.1),
                                            Colors.black,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              (attendanceData?.eventTitle?.trim().isNotEmpty ?? false)
                                                  ? attendanceData!.eventTitle!
                                                  : 'Event',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.ibmPlexSans(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: AppColor.white,
                                              ),
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
          
                        SizedBox(height: 20),
          
                        Row(
                          children: [
                            Text(
                              '${attendanceData?.monthName ?? ''} Overall Attendance ',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Average',
                              style: GoogleFonts.ibmPlexSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.orange,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
          
                        GradientProgressBar(
                          progress: (attendanceData?.thisMonthPresentPercentage ?? 0) / 100,
                        ),
          
                        SizedBox(height: 15),
          
                        Text(
                          "${attendanceData?.fullDayPresentCount ?? '0'} Out of ${attendanceData?.totalWorkingDays ?? '0'}",
                          style: GoogleFonts.ibmPlexSans(
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
                          style: GoogleFonts.ibmPlexSans(
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