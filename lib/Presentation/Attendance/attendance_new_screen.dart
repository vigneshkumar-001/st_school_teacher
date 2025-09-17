import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:st_teacher_app/Core/Utility/custom_app_button.dart';
import 'package:st_teacher_app/Core/consents.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../../dummy_screen.dart';
import 'attendance_history.dart';
import 'controller/attendance_controller.dart';
import 'model/attendence_response.dart';

class Student {
  final int id;
  final String name;
  bool isPresent; // <-- new field

  Student({
    required this.id,
    required this.name,
    this.isPresent = false, // default
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class AttendanceNewScreen extends StatefulWidget {
  const AttendanceNewScreen({super.key});

  @override
  State<AttendanceNewScreen> createState() => _AttendanceNewScreenState();
}

class _AttendanceNewScreenState extends State<AttendanceNewScreen> {
  final AttendanceController controller = Get.put(AttendanceController());
  bool agreed = false;
  bool isChecked = false;
  bool showError = false;
  bool isSelected = false;
  int selectedIndex = 0; // 0:Present 1:Absent 2:Pending 3:Later
  int subjectIndex = 0;
  bool _pendingTabTapped = false;
  bool _laterTabTapped = false;
  int pendingStudentIndex = 0;
  List<AttendanceModel> markedAttendance = [];
  int _selectedPill = 0;
  bool morningDone = false;
  var selectedClass;
  int selectedLaterStudentIndex = 0;
  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );
  bool _selectAll = false;
  bool _showError = false;
  final List<_Student> _students = [
    _Student('Kanjana'),
    _Student('Olivia'),
    _Student('Juliya'),
    _Student('Marie'),
    _Student('Christiana'),
    _Student('Olivia'),
    _Student('Stella'),
    _Student('Marie'),
  ];

  int get presentCount => _students.where((s) => s.isPresent).length;
  int get absentCount => _students.length - presentCount;

  void _toggleSelectAll() {
    final newValue = !_selectAll;
    _selectAll = newValue;

    for (var i = 0; i < controller.students.length; i++) {
      controller.students[i].isPresent = newValue;
    }

    controller.students.refresh();
    setState(() {});
  }

  void _toggleSingle(int index) {
    final student = controller.students[index];
    student.isPresent = !student.isPresent;
    controller.students[index] = student; // update observable

    // If at least one is unchecked → SelectAll should be false
    _selectAll = controller.students.every((s) => s.isPresent);

    controller.students.refresh();
    setState(() {});
  }

  // Example validate: show red border on any unchecked if required
  Future<void> _validateBeforeSubmit() async {
    final hasSelection = _students.any((s) => s.isPresent);

    ScaffoldMessenger.of(context).clearSnackBars();

    if (!hasSelection) {
      // optional vibration so it "feels" like an error
      HapticFeedback.heavyImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
          content: Row(
            children: const [
              Icon(Icons.error_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Please select at least one student before submitting.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
      return; // stop here on error
    }

    // success flow
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColor.green, // your green color
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Attendance submitted',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => AttendanceHistory()),
    // );

    // TODO: await attendanceController.submit(...);
  }

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

        // Safe to rebuild here
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.students.isEmpty) {
            return const Center(child: Text("No students available"));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
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
                              builder: (context) => const AttendanceHistory(),
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
                            Image.asset(AppImages.historyImage, height: 24),
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
                  Text(
                    attendanceController.attendance.value?.messages ?? '',
                    textAlign: TextAlign.center,
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColor.gray.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Note ',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 13,
                                color: AppColor.black.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Select Presents Only, UnSelected Consider as Absent',
                              style: GoogleFont.ibmPlexSans(
                                fontSize: 13,
                                color: AppColor.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColor.lowLightgray,
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      children: [
                        // ✅ Select All
                        CommonContainer.tickContainer(
                          iconOnTap: () {},
                          isChecked: _selectAll,
                          onTap: _toggleSelectAll,
                          text: 'Select All',
                          textColor1: AppColor.gray,
                          isError:
                              _showError && !_selectAll && presentCount == 0,
                          borderColor:
                              _showError && presentCount == 0
                                  ? Colors.red
                                  : AppColor.lowLightgray,
                        ),
                        const SizedBox(height: 14),
                        Divider(color: AppColor.lowLightgray),

                        // ✅ Student List
                        ...List.generate(controller.students.length, (i) {
                          final s = controller.students[i];
                          return Column(
                            children: [
                              const SizedBox(height: 14),
                              CommonContainer.tickContainer(
                                iconImage: true,
                                iconOnTap: () {
                                  // optional: add detail navigation here
                                },
                                isChecked: s.isPresent,
                                onTap:
                                    () => _toggleSingle(
                                      i,
                                    ), // Update logic to modify student
                                text: s.name,
                                textColor1: AppColor.black,
                                isError:
                                    _showError &&
                                    !s.isPresent &&
                                    controller.presentCount == 0,
                                borderColor:
                                    _showError && controller.presentCount == 0
                                        ? Colors.red
                                        : AppColor.lowLightgray,
                              ),
                              const SizedBox(height: 14),
                              if (i != controller.students.length - 1)
                                Divider(color: AppColor.lowLightgray),
                            ],
                          );
                        }),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Obx(
                                () => _pill(
                                  selected: false,
                                  onTap: null,
                                  count: controller.presentCount,
                                  label: 'Present',
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Obx(
                              () => _pill(
                                count: controller.absentCount, // ✅ auto updates
                                label: 'Absent',
                                selected: false,
                                onTap: null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        AppButton.button(
                          text: 'Submit',
                          onTap: () {
                            final payload = _validateBeforeSubmit();
                          },
                          width: double.infinity,
                          height: 46,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),

      /*Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 35,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.blue.shade50
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '7 ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        isSelected ? Colors.blue : Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Present',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isSelected ? Colors.blue : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 35,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.blue.shade50
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '1 ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        isSelected ? Colors.blue : Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Absent',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isSelected ? Colors.blue : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),*/
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
                      if (data != null) {}
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

  Widget _pill({
    int count = 0,
    required String label,
    required bool selected,
    VoidCallback? onTap,
    bool showCount = true, // ← new
    double horizontalPadding = 40,
  }) {
    final Color border = selected ? AppColor.blue : AppColor.borderGary;
    final Color text = selected ? AppColor.blue : AppColor.gray;
    final Color bg = selected ? Colors.blue.shade50 : AppColor.white;

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCount) ...[
            Text(
              '$count ',
              style: GoogleFont.ibmPlexSans(
                fontSize: 13,
                color: text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          Text(
            label,
            style: GoogleFont.ibmPlexSans(
              fontSize: 13,
              color: text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    return onTap == null
        ? child
        : Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(25),
            child: child,
          ),
        );
  }
}

class _Student {
  final String name;
  bool isPresent;
  _Student(this.name, {this.isPresent = false});
}
