import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'attendance_history.dart';
import 'attendance_history_student.dart';
import 'model/attendence_response.dart';
import 'controller/attendance_controller.dart';

class AttendanceModel {
  final int studentId;
  final int classId;
  String status;

  AttendanceModel({
    required this.studentId,
    required this.classId,
    this.status = "",
  });

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "classId": classId,
    "status": status,
  };
}

class AttendanceStart extends StatefulWidget {
  const AttendanceStart({super.key});

  @override
  State<AttendanceStart> createState() => _AttendanceStartState();
}

class _AttendanceStartState extends State<AttendanceStart> {
  int selectedIndex = 0; // 0:Present 1:Absent 2:Pending 3:Later
  int subjectIndex = 0;
  bool _pendingTabTapped = false;
  bool _laterTabTapped = false;

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
  List<AttendanceModel> markedAttendance = [];

  bool morningDone = false;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   attendanceController.getClassList().then((_) async {
  //     if (attendanceController.classList.isNotEmpty) {
  //       selectedClass = attendanceController.classList.first;
  //
  //       final attendanceData = await attendanceController.getTodayStatus(
  //         selectedClass.id,
  //       );
  //       if (attendanceData != null) {
  //         _prepareTabs(attendanceData);
  //       }
  //       setState(() {});
  //     }
  //   });
  // }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await attendanceController.getClassList();

      if (attendanceController.classList.isNotEmpty) {
        selectedClass = attendanceController.classList.first;

        final attendanceData = await attendanceController.getTodayStatus(
          selectedClass.id,
        );
        if (attendanceData != null) {
          _prepareTabs(attendanceData);
        }

        // Safe to rebuild here
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
    final pending = data.pendingAttendance;

    presentStudents = present.map((s) => {'name': s.name, 'id': s.id}).toList();
    absentStudents = absent.map((s) => {'name': s.name, 'id': s.id}).toList();
    laterStudents = late.map((s) => {'name': s.name, 'id': s.id}).toList();
    pendingStudents = pending.map((s) => {'name': s.name, 'id': s.id}).toList();

    tabs = [
      {'label': 'Present', 'count': presentStudents.length},
      {'label': 'Absent', 'count': absentStudents.length},
      {'label': 'Pending', 'count': pendingStudents.length},
      {'label': 'Later', 'count': laterStudents.length},
    ];
    setState(() {});
  }

  void markAttendance(Map<String, dynamic> student, String status) {
    final studentId = student['id'];
    final studentName = student['name'];

    final existing = markedAttendance.indexWhere(
      (s) => s.studentId == studentId,
    );
    if (existing != -1) {
      markedAttendance[existing].status = status;
    } else {
      markedAttendance.add(
        AttendanceModel(
          studentId: studentId,
          classId: selectedClass.id,
          status: status,
        ),
      );
    }

    setState(() {
      // remove from pending & later lists first
      pendingStudents.removeWhere((s) => s['id'] == studentId);
      laterStudents.removeWhere((s) => s['id'] == studentId);

      // add to target
      if (status == "present") {
        presentStudents.add(student);
      } else if (status == "absent") {
        absentStudents.add(student);
      } else if (status == "late") {
        laterStudents.add(student);
      }

      if (selectedLaterStudentIndex >= laterStudents.length) {
        selectedLaterStudentIndex = 0;
      }

      tabs = [
        {'label': 'Present', 'count': presentStudents.length},
        {'label': 'Absent', 'count': absentStudents.length},
        {'label': 'Pending', 'count': pendingStudents.length},
        {'label': 'Later', 'count': laterStudents.length},
      ];
    });

    _saveAttendanceInBackground(studentId, status);
  }

  Future<void> _saveAttendanceInBackground(int studentId, String status) async {
    try {
      await attendanceController.presentOrAbsent(
        studentId: studentId,
        status: status,
        classId: selectedClass.id,
      );
    } catch (e) {
      // handle/log if needed
    }
  }

  Widget _buildActionCard(bool loading) {
    // Hide the card on Present(0) & Absent(1)
    if (selectedIndex == 0 || selectedIndex == 1)
      return const SizedBox.shrink();

    // Hide on Pending when empty *until* user taps that tab
    if (selectedIndex == 2 && pendingStudents.isEmpty && !_pendingTabTapped) {
      return const SizedBox.shrink();
    }

    // Hide on Later when empty *until* user taps that tab
    if (selectedIndex == 3 && laterStudents.isEmpty && !_laterTabTapped) {
      return const SizedBox.shrink();
    }

    final showButtons =
        (selectedIndex == 2 && pendingStudents.isNotEmpty) ||
        (selectedIndex == 3 && laterStudents.isNotEmpty);

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
                const Spacer(),
                InkWell(
                  onTap:
                      loading
                          ? null
                          : () {
                            if (selectedIndex == 3 &&
                                laterStudents.isNotEmpty) {
                              markAttendance(
                                laterStudents[selectedLaterStudentIndex],
                                'late',
                              );
                            } else if (selectedIndex == 2 &&
                                pendingStudents.isNotEmpty) {
                              markAttendance(
                                pendingStudents[pendingStudentIndex],
                                'late',
                              );
                            }
                          },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      'Later',
                      style: GoogleFont.ibmPlexSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color:
                            loading
                                ? AppColor.blue.withOpacity(0.6)
                                : AppColor.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Title or Empty text (only after tab is tapped)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
              child: Builder(
                key: ValueKey('title-$selectedIndex'),
                builder: (_) {
                  if (selectedIndex == 3) {
                    if (laterStudents.isNotEmpty) {
                      return Text(
                        laterStudents[selectedLaterStudentIndex]['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return Text(
                      _laterTabTapped ? 'No Later Students' : '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    if (pendingStudents.isNotEmpty) {
                      return Text(
                        pendingStudents[pendingStudentIndex]['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return Text(
                      _pendingTabTapped ? 'No Pending Students' : '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
            ),

            if (showButtons)
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
                              : () {
                                if (selectedIndex == 2 &&
                                    pendingStudents.isNotEmpty) {
                                  markAttendance(
                                    pendingStudents[pendingStudentIndex],
                                    'absent',
                                  );
                                } else if (selectedIndex == 3 &&
                                    laterStudents.isNotEmpty) {
                                  markAttendance(
                                    laterStudents[selectedLaterStudentIndex],
                                    'absent',
                                  );
                                }
                              },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              loading
                                  ? AppColor.red.withOpacity(0.6)
                                  : AppColor.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 13,
                          ),
                          child: SizedBox(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.close,
                                  height: 19.62,
                                  color: AppColor.white,
                                ),
                                const SizedBox(width: 7),
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
                    ),
                    const Spacer(),
                    InkWell(
                      onTap:
                          loading
                              ? null
                              : () {
                                if (selectedIndex == 2 &&
                                    pendingStudents.isNotEmpty) {
                                  markAttendance(
                                    pendingStudents[pendingStudentIndex],
                                    'present',
                                  );
                                } else if (selectedIndex == 3 &&
                                    laterStudents.isNotEmpty) {
                                  markAttendance(
                                    laterStudents[selectedLaterStudentIndex],
                                    'present',
                                  );
                                }
                              },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              loading
                                  ? AppColor.green.withOpacity(0.6)
                                  : AppColor.green,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 13,
                          ),
                          child: SizedBox(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.tick,
                                  height: 19.62,
                                  color: AppColor.white,
                                ),
                                const SizedBox(width: 7),
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
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lowLightgray,
      body: SafeArea(
        child: Obx(
          () =>
              attendanceController.isLoading.value
                  ? Center(child: AppLoader.circularLoader())
                  : SingleChildScrollView(
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
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const AttendanceHistory(),
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
                              SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.gray),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    attendanceController
                                            .attendance
                                            .value
                                            ?.messages ??
                                        '',
                                    textAlign: TextAlign.center,
                                    style: GoogleFont.ibmPlexSans(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),

                              // === ACTION CARD (hidden on Present/Absent) ===
                              Obx(() {
                                final loading =
                                    attendanceController.isPresentLoading.value;
                                return _buildActionCard(loading);
                              }),

                              SizedBox(height: 20),
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
                                child: Column(
                                  children: [
                                    // Top chips
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                          horizontal: 10,
                                        ),
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
                                                    () => setState(() {
                                                      selectedIndex = index;
                                                      if (index == 2)
                                                        _pendingTabTapped =
                                                            true;
                                                      if (index == 3)
                                                        _laterTabTapped = true;
                                                    }),
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
                                                    "${tabs[index]['count']} ${tabs[index]['label']}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      child: Column(
                                        children: [
                                          if (selectedIndex == 0) ...[
                                            for (var student in presentStudents)
                                              CommonContainer.StudentsList(
                                                mainText: student['name'],
                                                onIconTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (
                                                            context,
                                                          ) => AttendanceHistoryStudent(
                                                            studentId:
                                                                student['id'],
                                                            classId:
                                                                selectedClass
                                                                    .id,
                                                          ),
                                                    ),
                                                  );
                                                },
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
                                                  style: GoogleFont.ibmPlexSans(
                                                    color: AppColor.gray,
                                                  ),
                                                ),
                                              )
                                            else
                                              for (var student
                                                  in pendingStudents)
                                                CommonContainer.StudentsList(
                                                  mainText: student['name'],
                                                  onIconTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (
                                                              context,
                                                            ) => AttendanceHistoryStudent(
                                                              studentId:
                                                                  student['id'],
                                                              classId:
                                                                  selectedClass
                                                                      .id,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                          ] else if (selectedIndex == 3) ...[
                                            if (laterStudents.isEmpty)
                                              Center(
                                                child: Text(
                                                  'No students',
                                                  style: GoogleFont.ibmPlexSans(
                                                    color: AppColor.gray,
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
                                                          i;
                                                    });
                                                  },
                                                ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
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

      // Bottom class switcher
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(color: AppColor.white),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(attendanceController.classList.length, (
                index,
              ) {
                final isSelected = subjectIndex == index;
                final classItem = attendanceController.classList[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      subjectIndex = index;
                      selectedClass = attendanceController.classList[index];
                      // reset per-class temp state
                      selectedIndex = 0;
                      _pendingTabTapped = false;
                      _laterTabTapped = false;
                      pendingStudentIndex = 0;
                      selectedLaterStudentIndex = 0;
                    });

                    attendanceController.getTodayStatus(selectedClass.id).then((
                      data,
                    ) {
                      if (data != null) {
                        _prepareTabs(data);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 55, vertical: 9),
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
