// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:st_teacher_app/Presentation/Homework/controller/create_homework_controller.dart';
//
// import '../../Core/Utility/app_color.dart';
// import '../../Core/Utility/app_images.dart';
// import '../../Core/Utility/custom_app_button.dart';
// import '../../Core/Utility/google_fonts.dart';
// import '../../Core/Widgets/common_container.dart';
// import 'package:get/get.dart';
//
// class HomeworkHistoryDetails extends StatefulWidget {
//   final int homeworkId;
//   const HomeworkHistoryDetails({super.key, required this.homeworkId});
//
//   @override
//   State<HomeworkHistoryDetails> createState() => _HomeworkHistoryDetailsState();
// }
//
// class _HomeworkHistoryDetailsState extends State<HomeworkHistoryDetails> {
//   final CreateHomeworkController controller = Get.put(
//     CreateHomeworkController(),
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.getHomeWorkDetails(classId: widget.homeworkId);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.lowLightgray,
//       body: SafeArea(
//         child: Obx(() {
//           final details = controller.homeworkDetails.value;
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CommonContainer.NavigatArrow(
//                     image: AppImages.leftSideArrow,
//                     imageColor: AppColor.lightBlack,
//                     container: AppColor.lowLightgray,
//                     onIconTap: () => Navigator.pop(context),
//                     border: Border.all(color: AppColor.lightgray, width: 0.3),
//                   ),
//                   SizedBox(height: 35),
//                   Center(
//                     child: Text(
//                       'Homework Preview',
//                       style: GoogleFont.inter(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w600,
//                         color: AppColor.black,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: AppColor.white,
//                       // gradient: LinearGradient(
//                       //   colors: [
//                       //     AppColor.lowLightYellow,
//                       //     AppColor.lowLightYellow,
//                       //     AppColor.lowLightYellow,
//                       //     AppColor.lowLightYellow,
//                       //     AppColor.lowLightYellow,
//                       //     AppColor.lowLightYellow,
//                       //     AppColor.lowLightYellow.withOpacity(0.2),
//                       //   ], // gradient top to bottom
//                       //   begin: Alignment.topCenter,
//                       //   end: Alignment.bottomCenter,
//                       // ),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 30),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 30),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Image.asset(AppImages.homeworkPreviewImage1),
//                                 SizedBox(height: 20),
//                                 Image.asset(AppImages.homeworkPreviewImage2),
//                                 SizedBox(height: 20),
//                                 Text(
//                                   details?.title ?? '',
//                                   style: GoogleFont.inter(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 24,
//                                     color: AppColor.lightBlack,
//                                   ),
//                                 ),
//                                 SizedBox(height: 15),
//                                 Text(
//                                   details?.description ?? '',
//                                   style: GoogleFont.inter(
//                                     fontSize: 12,
//                                     color: AppColor.gray,
//                                   ),
//                                 ),
//                                 SizedBox(height: 15),
//
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ...List.generate(
//                                       details?.tasks.length ?? 0,
//                                           (index) {
//                                         final task = details!.tasks[index];
//                                         final content = task['content'] ?? '';
//                                         return Text(
//                                           '${index + 1}. $content',
//                                           style: GoogleFont.inter(
//                                             fontSize: 12,
//                                             color: AppColor.gray,
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 20),
//
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 15,
//                                 horizontal: 25,
//                               ),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: AppColor.black.withOpacity(0.05),
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           CircleAvatar(
//                                             child: Image.asset(
//                                               AppImages.avatar1,
//                                             ),
//                                           ),
//                                           SizedBox(width: 10),
//                                           Text(
//                                             '${details?.subject.name}',
//                                             style: GoogleFont.inter(
//                                               fontSize: 12,
//                                               color: AppColor.lightBlack,
//                                             ),
//                                           ),
//                                           SizedBox(width: 20),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 20),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       color: AppColor.black.withOpacity(0.05),
//                                       borderRadius: BorderRadius.circular(50),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(10),
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             CupertinoIcons.clock_fill,
//                                             size: 35,
//                                             color: AppColor.lightBlack
//                                                 .withOpacity(0.3),
//                                           ),
//                                           SizedBox(width: 10),
//                                           Text(
//                                             details?.time ?? '',
//                                             style: GoogleFont.inter(
//                                               fontSize: 12,
//                                               color: AppColor.lightBlack,
//                                             ),
//                                           ),
//                                           SizedBox(width: 10),
//                                           Text(
//                                             details?.date ?? '',
//                                             style: GoogleFont.inter(
//                                               fontSize: 12,
//                                               color: AppColor.gray,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_teacher_app/Presentation/Attendance/controller/attendance_controller.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/app_loader.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import 'Presentation/Attendance/attendance_history.dart';
import 'Presentation/Attendance/attendance_history_student.dart';
import 'Presentation/Attendance/model/attendence_response.dart';

class AttendanceModel {
  final int studentId;
  final int classId;
  String status; // "present", "absent", "late"

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
  List<AttendanceModel> markedAttendance = [];

  /*  void markAttendanceForCurrentStudent(String status) async {
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
  }*/

  void markAttendanceForCurrentStudent(String status) {
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

    final studentId = student!['id'];
    final studentName = student['name'];

    // ✅ compare int with int
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

    // ✅ print for debugging
    print("✅ Marked $studentName as $status");

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

  String getStudentStatus(int studentId) {
    final entry = markedAttendance.firstWhere(
      (s) => s.studentId == studentId,
      orElse: () => AttendanceModel(studentId: -1, classId: -1, status: ""),
    );
    return entry.status;
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
                  ? Center(child: AppLoader.circularLoader( ))
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
                                                      child: SizedBox(
                                                        width: 80,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            if (currentStatusLoading ==
                                                                    'absent' &&
                                                                loading)
                                                              SizedBox(
                                                                height: 24,
                                                                width: 24,
                                                                child:
                                                                    AppLoader.circularLoader(

                                                                    ),
                                                              )
                                                            else ...[
                                                              Image.asset(
                                                                AppImages.close,
                                                                height: 19.62,
                                                                color:
                                                                    AppColor
                                                                        .white,
                                                              ),
                                                              SizedBox(
                                                                width: 7,
                                                              ),
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
                                                        width: 80,
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
                                              onIconTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => AttendanceHistoryStudent(
                                                          studentId:
                                                              student['id'], // ✅ use actual key from map
                                                          classId:
                                                              selectedClass
                                                                  .id, // ✅ pass classId
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
                                                  selectedLaterStudentIndex = i;
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
