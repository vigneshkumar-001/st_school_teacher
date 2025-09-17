import 'package:dartz/dartz_unsafe.dart' as data;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Presentation/Exam%20Screen/screens/exam_history.dart';
import '../../../Core/Utility/app_color.dart';
import '../../../api/data_source/apiDataSource.dart';
import '../../Homework/model/teacher_class_response.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:st_teacher_app/Core/consents.dart';
import '../../../Core/Utility/snack_bar.dart';
import '../model/exam_list_response.dart';
import '../model/student_marks_response.dart';

class ExamController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();

  RxInt subjectIndex = 0.obs; // currently active subject
  RxInt maxShownIndex = 0.obs; // highest subject revealed
  RxBool isLoading = false.obs;
  final RxList<String> categoryOptions = <String>[].obs;
  final RxBool isCategoryLoading = false.obs;
  final RxString categoryError = ''.obs;
  String accessToken = '';
  var currentIndex = 0.obs;
  RxString frontImageUrl = ''.obs;
  RxList<Exam> exam = <Exam>[].obs;
  RxList<ExamStudent> examStudent = <ExamStudent>[].obs;

  @override
  void onInit() {
    super.onInit();
    getExamList();
  }

  RxString selectedFilter = "All".obs;

  RxList<String> monthFilters = <String>[].obs;
  void buildMonthFilters() {
    final months = <String>{};

    for (var e in exam) {
      final date = DateTime.tryParse(e.time); // ✅ use 'time'
      if (date != null) {
        final monthYear = DateFormat("MMMM yyyy").format(date);
        months.add(monthYear);
      }
    }

    monthFilters.value = ["All", ...months.toList()]; // Always add "All"
  }


  RxList<Exam> get filteredExams {
    if (selectedFilter.value == "All") return exam;
    return exam.where((e) {
      final date = DateTime.tryParse(e.time);
      if (date == null) return false;
      final monthYear = DateFormat("MMMM yyyy").format(date);
      return monthYear == selectedFilter.value;
    }).toList().obs; // <-- make it reactive
  }


  Map<String, List<Exam>> get groupedExams {
    final Map<String, List<Exam>> grouped = {};

    // Use filtered exams based on selected filter
    final sourceList = selectedFilter.value == "All" ? exam : filteredExams;

    for (var e in sourceList) {
      final date = DateTime.tryParse(e.time); // ✅ use 'time' instead of 'startDate'
      if (date == null) continue;

      final now = DateTime.now();
      String key;

      if (DateUtils.isSameDay(date, now)) {
        key = "Today";
      } else if (DateUtils.isSameDay(date, now.subtract(const Duration(days: 1)))) {
        key = "Yesterday";
      } else {
        key = DateFormat("MMM dd, yyyy").format(date); // e.g. Sep 12, 2025
      }

      grouped.putIfAbsent(key, () => []).add(e);
    }

    return grouped;
  }


  Future<void> createExam({
    bool showLoader = true,
    BuildContext? context,
    required int classId,
    required String heading,
    required String startDate,
    required String endDate,
    required String announcementDate,
    File? imageFiles,
  }) async {
    try {
      if (showLoader) showPopupLoader();

      String? timetableUrl;

      // Upload timetable image if selected
      if (imageFiles != null) {
        final uploadResult = await apiDataSource.userProfileUpload(
          imageFile: imageFiles,
        );

        timetableUrl = uploadResult.fold((failure) {
          CustomSnackBar.showError("Image Upload Failed: ${failure.message}");
          return null;
        }, (success) => success.message);
      }

      final results = await apiDataSource.createExam(
        classId: classId,
        heading: heading,
        startDate: startDate,
        endDate: endDate,
        announcementDate: announcementDate,
        timetableUrl: timetableUrl,
      );

      results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          if (showLoader) hidePopupLoader();
          // Navigator.pop(context);
          await getExamList();
          Get.off(ExamHistory());
          AppLogger.log.i(response.message);
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
  }

  Future<void> markEnter({
    bool showLoader = false,

    BuildContext? context,
    required int examId,
    required int studentId,
    required int subjectId,
    required int mark,
  }) async {
    try {
      if (showLoader) showPopupLoader();

      final results = await apiDataSource.markEnter(
        examId: examId,
        studentId: studentId,
        subjectId: subjectId,
        mark: mark,
      );

      results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          if (showLoader) hidePopupLoader();
          // Navigator.pop(context);

          AppLogger.log.i(response.message);
          AppLogger.log.i('Mark Enter');
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
  }

  Future<void> getExamList() async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.getExamList();
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) {
          isLoading.value = false;
          exam.value = response.exams;
          buildMonthFilters(); // ⬅️ build dynamic filters here
          AppLogger.log.i(response.exams);
          AppLogger.log.i("Fetched ${exam.toJson()} ");
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
    }
  }

  Future<void> getStudentExamList({required int examId}) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.getStudentExamList(examId: examId);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) {
          isLoading.value = false;
          examStudent.value = response.students;
          currentIndex.value = 0; // start with first student
          subjectIndex.value = 0;
          AppLogger.log.i(response.students);
          AppLogger.log.i("Fetched ${examStudent.toJson()} ");
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
    }
  }

  void nextSubject({required int examId}) {
    final student = examStudent[currentIndex.value];
    final subject = student.marks[subjectIndex.value];

    // Store locally (update list value immediately)
    if (subject.obtainedMarks != null) {
      // Fire and forget API call in background
      markEnter(
        examId: examId,
        studentId: student.id,
        subjectId: subject.subjectId,
        mark: subject.obtainedMarks!,
        showLoader: false, // don't block UI
      );
    }

    if (subjectIndex.value < student.marks.length - 1) {
      subjectIndex.value++;
    }
  }

  void prevSubject() {
    if (subjectIndex.value > 0) {
      subjectIndex.value--; // move highlight to previous subject
    }
  }

  void clearDigit() {
    final student = examStudent[currentIndex.value];
    final mark = student.marks[subjectIndex.value];

    if (mark.obtainedMarks != null) {
      // Convert current value to string
      String current = mark.obtainedMarks.toString();
      if (current.length > 1) {
        // Remove last digit
        current = current.substring(0, current.length - 1);
        mark.obtainedMarks = int.parse(current);
      } else {
        // If only 1 digit, set null
        mark.obtainedMarks = null;
      }

      // Trigger UI update
      examStudent[currentIndex.value] = student;
    }
  }

  void typeDigit(int n) {
    final student = examStudent[currentIndex.value];
    final mark = student.marks[subjectIndex.value];

    // Current value as string
    String current = mark.obtainedMarks?.toString() ?? '';

    // Allow max 3 digits
    if (current.length >= 3) return;

    // Append new digit
    current += n.toString();

    mark.obtainedMarks = int.parse(current);

    // Trigger UI update
    examStudent[currentIndex.value] = student;
  }

  // --- Clear current subject ---
  void clearCurrentSubject() {
    final student = examStudent[currentIndex.value];
    student.marks[subjectIndex.value].obtainedMarks = null;
    examStudent[currentIndex.value] = student;
  }

  void nextStudent() {
    if (currentIndex.value < examStudent.length - 1) {
      currentIndex.value++;
    }
  }

  void previousStudent() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }
}

void showPopupLoader() {
  Get.dialog(
    Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: AppColor.black,
            strokeAlign: 1,
          ),
        ),
      ),
    ),
    barrierDismissible: false, // user can't dismiss by tapping outside
    barrierColor: Colors.black.withOpacity(0.3), // transparent background
  );
}

void hidePopupLoader() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}
