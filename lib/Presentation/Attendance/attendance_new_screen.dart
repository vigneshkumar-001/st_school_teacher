import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:st_teacher_app/Core/Utility/custom_app_button.dart';

import '../../Core/Utility/app_color.dart';
import '../../Core/Utility/app_images.dart';
import '../../Core/Utility/google_fonts.dart';
import '../../Core/Widgets/common_container.dart';
import '../../dummy_screen.dart';
import 'attendance_history.dart';
import 'controller/attendance_controller.dart';
import 'model/attendence_response.dart';

class AttendanceNewScreen extends StatefulWidget {
  const AttendanceNewScreen({super.key});

  @override
  State<AttendanceNewScreen> createState() => _AttendanceNewScreenState();
}

class _AttendanceNewScreenState extends State<AttendanceNewScreen> {
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
    setState(() {
      _selectAll = !_selectAll;
      for (final s in _students) {
        s.isPresent = _selectAll;
      }
      // if at least one selected now, hide error
      if (presentCount > 0) _showError = false;
    });
  }

  void _toggleSingle(int index) {
    setState(() {
      _students[index].isPresent = !_students[index].isPresent;
      _selectAll = _students.every((s) => s.isPresent);
      if (presentCount > 0) _showError = false;
    });
  }


  // Example validate: show red border on any unchecked if required
  void _validateBeforeSubmit() {
    final hasSelection = _students.any((s) => s.isPresent);

    // clear any existing snackbars first
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

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AttendanceHistory()),
    );

    // TODO: await attendanceController.submit(...);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      border: Border.all(color: AppColor.lightgray, width: 0.3),
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
                    text: '7th',
                    style: GoogleFont.ibmPlexSans(
                      fontSize: 14,
                      color: AppColor.gray,
                      fontWeight: FontWeight.w800,
                    ),
                    children: [
                      TextSpan(
                        text: ' C',
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
                SizedBox(height: 20),
                Text(
                  'Afternoon Attendance List',
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
                      // Select All
                      CommonContainer.tickContainer(

                        iconOnTap: () {},
                        isChecked: _selectAll,
                        onTap: _toggleSelectAll,
                        text: 'Select All',
                        textColor1: AppColor.gray,
                        isError: _showError && !_selectAll && presentCount == 0,
                        borderColor:
                            _showError && presentCount == 0
                                ? Colors.red
                                : AppColor.lowLightgray,
                      ),
                      const SizedBox(height: 14),
                      Divider(color: AppColor.lowLightgray),

                      // List
                      ...List.generate(_students.length, (i) {
                        final s = _students[i];
                        return Column(
                          children: [
                            const SizedBox(height: 14),
                            CommonContainer.tickContainer(
                              iconImage: true,
                              iconOnTap: () {
                                // Right-arrow action (optional)
                              },
                              isChecked: s.isPresent,
                              onTap: () => _toggleSingle(i),
                              text: s.name,
                              textColor1: AppColor.black,
                              isError:
                                  _showError &&
                                  !s.isPresent &&
                                  presentCount == 0,
                              borderColor:
                                  _showError && presentCount == 0
                                      ? Colors.red
                                      : AppColor.lowLightgray,
                            ),
                            const SizedBox(height: 14),
                            if (i != _students.length - 1)
                              Divider(color: AppColor.lowLightgray),
                          ],
                        );
                      }),

                      const SizedBox(height: 20),

                      // Quick stats
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: _pill(
                              selected: false,
                              onTap: null,
                              count: presentCount,
                              label: 'Present',
                            ),
                          ),
                          SizedBox(width: 4),
                          _pill(
                            count: absentCount,
                            label: 'Absent',
                            selected: false,
                            onTap: null,
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
        ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: AppColor.white),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
          child: Row(
            children: [
              _pill(
                horizontalPadding: 60,
                label: '7th C',
                selected: _selectedPill == 0,
                onTap: () => setState(() => _selectedPill = 0),
                showCount: false,
              ),
              const SizedBox(width: 12),
              _pill(
                horizontalPadding: 60,
                label: '11th C1',
                selected: _selectedPill == 1,
                onTap: () => setState(() => _selectedPill = 1),
                showCount: false,
              ),
            ],
          ),
        ),
      ),
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
