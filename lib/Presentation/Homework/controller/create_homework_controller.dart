import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/Utility/app_color.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/Presentation/Homework/homework_history.dart';
import 'package:st_teacher_app/Presentation/Homework/model/homework_details_response.dart';
import 'package:st_teacher_app/Presentation/Homework/model/teacher_class_response.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';

import '../model/get_homework_response.dart';

class CreateHomeworkController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();

  RxBool isLoading = false.obs;

  String accessToken = '';
  var homeworkList = <Homework>[].obs;
  Rxn<HomeworkDetails> homeworkDetails = Rxn<HomeworkDetails>();

  var selectedClassName = 'All'.obs;
  RxList<TeacherSubject> subjectList = <TeacherSubject>[].obs;
  List<Map<String, dynamic>> contents = [];
  var classNames = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchHomeworks();
  }

  Future<String?> createHomeWork({
    int? classId,
    int? subjectId,
    String heading = '',
    String description = '',
    bool publish = false,
    bool showLoader = true,
    contents,

    // Dynamic contents
  }) async {
    try {
      if (showLoader) showPopupLoader(); // show popup loader
      final results = await apiDataSource.createHomeWork(
        classId: classId ?? 0,
        subjectId: subjectId ?? 0,
        heading: heading,
        description: description,
        publish: publish,
        contents: contents,
      );
      results.fold(
        (failure) {
          if (showLoader) hidePopupLoader(); // hide popup loader
          AppLogger.log.e(failure.message);
        },
        (response) async {
          fetchHomeworks();
          if (showLoader) hidePopupLoader();
          Get.to(HomeworkHistory());
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<void> fetchHomeworks() async {
    try {
      isLoading.value = true;

      final result = await apiDataSource.getHomeWork();

      result.fold(
        (failure) {
          isLoading.value = false;
          Get.snackbar('Error', failure.message);
        },
        (response) {
          // Here, response is your GetHomeworkResponse object
          final data =
              response.data; // Correct: access 'data' from response object

          final List<Homework> loadedHomework = [];

          data.forEach((key, value) {
            loadedHomework.addAll(value);
            // value is already List<Homework>, no need to map again
          });

          homeworkList.value = loadedHomework;

          // Build classNames dynamically from homeworkList
          final classes =
              loadedHomework.map((hw) => hw.classNames.trim()).toSet().toList()
                ..sort();

          classNames.value = ['All', ...classes];

          isLoading.value = false;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  void selectClass(String className) {
    selectedClassName.value = className;
  }

  List<Homework> get filteredHomework {
    if (selectedClassName.value == 'All') {
      return homeworkList;
    }
    return homeworkList
        .where(
          (hw) =>
              hw.classNames.trim().toLowerCase() ==
              selectedClassName.value.trim().toLowerCase(),
        )
        .toList();
  }

  Map<String, List<Homework>> get groupedHomeworkByDate {
    Map<String, List<Homework>> grouped = {};

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    List<Homework> filteredList = filteredHomework;

    for (var hw in filteredList) {
      DateTime hwDate = DateTime.parse(hw.date.toString() ?? '');
      DateTime hwDateOnly = DateTime(hwDate.year, hwDate.month, hwDate.day);

      String key;
      if (hwDateOnly == today) {
        key = 'Today';
      } else if (hwDateOnly == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMM d, yyyy').format(hwDateOnly);
      }

      if (grouped.containsKey(key)) {
        grouped[key]!.add(hw);
      } else {
        grouped[key] = [hw];
      }
    }

    return grouped;
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

  Future<String?> getHomeWorkDetails({
    int? classId,

    bool showLoader = true,
  }) async {
    try {
      if (showLoader) showPopupLoader(); // show popup loader
      final results = await apiDataSource.getHomeWorkDetails(
        classId: classId ?? 0,
      );
      results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
        },
        (response) async {
          if (showLoader) hidePopupLoader();
          homeworkDetails.value = response;
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }
}
