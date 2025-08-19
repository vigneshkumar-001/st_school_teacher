import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_teacher_app/Presentation/Attendance/controller/attendance_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'attendance_history.dart';
import 'model/attendence_response.dart';

class AttendanceStart extends StatefulWidget {
  const AttendanceStart({super.key});

  @override
  State<AttendanceStart> createState() => _AttendanceStartState();
}

class _AttendanceStartState extends State<AttendanceStart> {
  int selectedIndex = 0;
  int subjectIndex = 0;
  var selectedClass;
  int selectedLaterStudentIndex = 0;
  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );

  List<Map<String, dynamic>> tabs = [];
  List<Map<String, dynamic>> pendingStudents = [];
  List<Map<String, dynamic>> presentStudents = [];
  List<Map<String, dynamic>> absentStudents = [];
  List<Map<String, dynamic>> laterStudents = [];

  int pendingStudentIndex = 0;

  void markAttendanceForCurrentStudent(String status) async {
    // Determine student & index based on selected tab
    Map<String, dynamic>? student;

    if (selectedIndex == 3) {
      if (laterStudents.isEmpty ||
          selectedLaterStudentIndex >= laterStudents.length)
        return;
      student = laterStudents[selectedLaterStudentIndex];
    } else {
      if (pendingStudents.isEmpty ||
          pendingStudentIndex >= pendingStudents.length)
        return;
      student = pendingStudents[pendingStudentIndex];
    }

    attendanceController.currentLoadingStatus.value = status;
    attendanceController.isPresentLoading.value = true;

    bool success = await attendanceController.presentOrAbsent(
      studentId: student['id'],
      status: status,
      classId: selectedClass.id,
    );

    if (success) {
      final updatedData = await attendanceController.getTodayStatus(
        selectedClass.id,
        showLoader: false,
      );

      if (updatedData != null) {
        _prepareTabs(updatedData);

        setState(() {
          if (selectedIndex == 3) {
            if (laterStudents.isNotEmpty) {
              selectedLaterStudentIndex =
                  (selectedLaterStudentIndex + 1) % laterStudents.length;
            } else {
              selectedLaterStudentIndex = 0;
            }
          } else {
            if (pendingStudents.isNotEmpty) {
              pendingStudentIndex =
                  (pendingStudentIndex + 1) % pendingStudents.length;
            } else {
              pendingStudentIndex = 0;
            }
          }
        });
      }
    } else {}

    attendanceController.isPresentLoading.value = false;
    attendanceController.currentLoadingStatus.value = '';
  }

  bool morningDone = false;

  @override
  void initState() {
    super.initState();

    attendanceController.getClassList().then((_) async {
      if (attendanceController.classList.isNotEmpty) {
        selectedClass = attendanceController.classList.first;

        final attendanceData = await attendanceController.getTodayStatus(
          selectedClass.id,
        );
        if (attendanceData != null) {
          _prepareTabs(attendanceData);
        }
        setState(() {});
      }
    });
  }

  void _prepareTabs(AttendanceData data) {
    morningDone = data.morningAttendanceDone;

    final present =
        morningDone
            ? data.presentStudentsAfternoon
            : data.presentStudentsMorning;
    final absent =
        morningDone ? data.absentStudentsAfternoon : data.absentStudentsMorning;
    final late =
        morningDone ? data.lateStudentsAfternoon : data.lateStudentsMorning;
    final pending = data.pendingAttendance; // pending probably stays the same

    presentStudents = present.map((s) => {'name': s.name, 'id': s.id}).toList();
    absentStudents = absent.map((s) => {'name': s.name, 'id': s.id}).toList();
    laterStudents = late.map((s) => {'name': s.name, 'id': s.id}).toList();
    pendingStudents = pending.map((s) => {'name': s.name, 'id': s.id}).toList();

    setState(() {
      tabs = [
        {'label': 'Present', 'count': presentStudents.length},
        {'label': 'Absent', 'count': absentStudents.length},
        {'label': 'Pending', 'count': pendingStudents.length},
        {'label': 'Later', 'count': laterStudents.length},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(
          () =>
              attendanceController.isLoading.value
                  ? Center(child: AppLoader.circularLoader(Colors.black))
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
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
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => AttendanceHistory(),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'History',
                                          style: GoogleFont.ibmPlexSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.gray,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Image.asset(
                                          AppImages.historyImage,
                                          height: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              RichText(
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

                              SizedBox(height: 3),

                              Text(
                                attendanceController
                                        .attendance
                                        .value
                                        ?.messages ??
                                    '',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black,
                                ),
                              ),
                              SizedBox(height: 20),
                              Obx(() {
                                final loading =
                                    attendanceController.isPresentLoading.value;
                                final currentStatusLoading =
                                    attendanceController
                                        .currentLoadingStatus
                                        .value;

                                return Container(
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
                                              onTap:
                                                  loading
                                                      ? null
                                                      : () =>
                                                          markAttendanceForCurrentStudent(
                                                            'late',
                                                          ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                child:
                                                    currentStatusLoading ==
                                                                'late' &&
                                                            loading
                                                        ? SizedBox(
                                                          height: 18,
                                                          width: 18,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color:
                                                                    AppColor
                                                                        .blue,
                                                              ),
                                                        )
                                                        : Text(
                                                          'Later',
                                                          style: GoogleFont.ibmPlexSans(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                loading
                                                                    ? AppColor
                                                                        .blue
                                                                        .withOpacity(
                                                                          0.6,
                                                                        )
                                                                    : AppColor
                                                                        .blue,
                                                          ),
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // AnimatedSwitcher for student name
                                        AnimatedSwitcher(
                                          duration: Duration(milliseconds: 300),
                                          transitionBuilder:
                                              (child, animation) =>
                                                  SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: const Offset(1, 0),
                                                      end: Offset.zero,
                                                    ).animate(animation),
                                                    child: FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    ),
                                                  ),
                                          child: Text(
                                            selectedIndex == 3
                                                ? (laterStudents.isNotEmpty
                                                    ? laterStudents[selectedLaterStudentIndex]['name']
                                                    : 'No Later Students')
                                                : (pendingStudents.isNotEmpty
                                                    ? pendingStudents[pendingStudentIndex]['name']
                                                    : 'No Pending Students'),
                                            key: ValueKey(
                                              selectedIndex == 3
                                                  ? (laterStudents.isNotEmpty
                                                      ? laterStudents[selectedLaterStudentIndex]['id']
                                                      : 'empty-later')
                                                  : (pendingStudents.isNotEmpty
                                                      ? pendingStudents[pendingStudentIndex]['id']
                                                      : 'empty-pending'),
                                            ),
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        if ((selectedIndex == 2 &&
                                                pendingStudents.isNotEmpty &&
                                                pendingStudentIndex <
                                                    pendingStudents.length) ||
                                            (selectedIndex == 3 &&
                                                laterStudents.isNotEmpty &&
                                                selectedLaterStudentIndex <
                                                    laterStudents.length))
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 20,
                                            ),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap:
                                                      loading
                                                          ? null
                                                          : () =>
                                                              markAttendanceForCurrentStudent(
                                                                'absent',
                                                              ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          loading
                                                              ? AppColor.red
                                                                  .withOpacity(
                                                                    0.6,
                                                                  )
                                                              : AppColor.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 32,
                                                            vertical: 13,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          if (currentStatusLoading ==
                                                                  'absent' &&
                                                              loading)
                                                            SizedBox(
                                                              height: 18,
                                                              width: 18,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            )
                                                          else ...[
                                                            Image.asset(
                                                              AppImages.close,
                                                              height: 20.86,
                                                              color:
                                                                  AppColor
                                                                      .white,
                                                            ),
                                                            SizedBox(width: 7),
                                                            Text(
                                                              'Absent',
                                                              style: GoogleFont.ibmPlexSans(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    AppColor
                                                                        .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap:
                                                      loading
                                                          ? null
                                                          : () =>
                                                              markAttendanceForCurrentStudent(
                                                                'present',
                                                              ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          loading
                                                              ? AppColor.green
                                                                  .withOpacity(
                                                                    0.6,
                                                                  )
                                                              : AppColor.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 32,
                                                            vertical: 13,
                                                          ),
                                                      child: SizedBox(
                                                        width: 90,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            if (currentStatusLoading ==
                                                                    'present' &&
                                                                loading)
                                                              SizedBox(
                                                                height: 24,
                                                                width: 24,
                                                                child:
                                                                    AppLoader.circularLoader(
                                                                      Colors
                                                                          .white,
                                                                    ),
                                                              )
                                                            else ...[
                                                              Image.asset(
                                                                AppImages.tick,
                                                                height: 19.62,
                                                                color:
                                                                    AppColor
                                                                        .white,
                                                              ),
                                                              SizedBox(
                                                                width: 7,
                                                              ),
                                                              Text(
                                                                'Present',
                                                                style: GoogleFont.ibmPlexSans(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      AppColor
                                                                          .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ],
                                                        ),
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
                                );
                              }),

                              const SizedBox(height: 20),
                              Text(
                                'Students List',
                                style: GoogleFont.ibmPlexSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black,
                                ),
                              ),

                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(tabs.length, (
                                            index,
                                          ) {
                                            final isSelected =
                                                selectedIndex == index;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                  ),
                                              child: GestureDetector(
                                                onTap:
                                                    () => setState(
                                                      () =>
                                                          selectedIndex = index,
                                                    ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 9,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        isSelected
                                                            ? AppColor.white
                                                            : AppColor
                                                                .lowLightgray,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          isSelected
                                                              ? AppColor.blue
                                                              : Colors
                                                                  .transparent,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    "${tabs[index]['count']} ${tabs[index]['label']}",
                                                    style:
                                                        GoogleFont.ibmPlexSans(
                                                          fontSize: 12,
                                                          color:
                                                              isSelected
                                                                  ? AppColor
                                                                      .blue
                                                                  : AppColor
                                                                      .gray,
                                                          fontWeight:
                                                              isSelected
                                                                  ? FontWeight
                                                                      .w700
                                                                  : FontWeight
                                                                      .w400,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      // Student Lists
                                      if (selectedIndex == 0) ...[
                                        for (var student in presentStudents)
                                          CommonContainer.StudentsList(
                                            mainText: student['name'],
                                            onIconTap: () {},
                                          ),
                                      ] else if (selectedIndex == 1) ...[
                                        for (var student in absentStudents)
                                          CommonContainer.StudentsList(
                                            mainText: student['name'],
                                            onIconTap: () {},
                                          ),
                                      ] else if (selectedIndex == 2) ...[
                                        if (pendingStudents.isEmpty)
                                          Center(
                                            child: Text(
                                              'No pending students',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        else
                                          for (var student in pendingStudents)
                                            CommonContainer.StudentsList(
                                              mainText: student['name'],
                                              onIconTap: () {},
                                            ),
                                      ] else if (selectedIndex == 3) ...[
                                        if (laterStudents.isEmpty)
                                          Center(
                                            child: Text(
                                              'No students',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        else
                                          for (
                                            var i = 0;
                                            i < laterStudents.length;
                                            i++
                                          )
                                            CommonContainer.StudentsList(
                                              mainText:
                                                  laterStudents[i]['name'],
                                              onIconTap: () {
                                                setState(() {
                                                  selectedLaterStudentIndex =
                                                      i; // update selected student
                                                });
                                              },
                                            ),
                                      ],
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
        ),
      ),

      // Bottom nav - class selection
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(color: AppColor.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(attendanceController.classList.length, (
                index,
              ) {
                final isSelected = subjectIndex == index;
                final classItem = attendanceController.classList[index];

                return GestureDetector(
                  onTap: () {
                    // First update the state synchronously
                    setState(() {
                      subjectIndex = index;
                      selectedClass = attendanceController.classList[index];
                    });

                    // Then fetch data async
                    attendanceController.getTodayStatus(selectedClass.id).then((
                      data,
                    ) {
                      if (data != null) {
                        _prepareTabs(data);
                      }
                    });
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 55,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? AppColor.blue : AppColor.borderGary,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      "${classItem.className} ${classItem.section}",
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 11,
                        color: isSelected ? AppColor.blue : AppColor.gray,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
