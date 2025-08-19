import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';

import '../../../Core/Utility/app_color.dart';
import '../model/attendence_student_history.dart';
import '../model/student_attendance_response.dart';

class StudentAttendanceController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;
  RxBool isLoading = false.obs;

  String accessToken = '';
  Rx<StudentAttendanceData?> attendanceStudentHistory =
      Rx<StudentAttendanceData?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  Future<StudentAttendanceData?> studentDayAttendance({
    required int studentId,
    required int classId,
    required DateTime date,
    bool showLoader = true,
  }) async {
    try {
      if (showLoader) showPopupLoader();
      final results = await apiDataSource.studentDayAttendance(
        studentId: studentId,
        classId: classId,
        date: date,
      );

      return await results.fold(
        (failure) {
          if (showLoader) hidePopupLoader(); // hide popup loader
          AppLogger.log.e(failure.message);
          return null;
        },
        (response) {
          if (showLoader) hidePopupLoader(); // hide popup loader
          attendanceStudentHistory.value = response.data;
          return response.data;
        },
      );
    } catch (e, stacktrace) {
      if (showLoader) hidePopupLoader(); // hide popup loader
      AppLogger.log.e(
        'Exception in studentDayAttendance',
        error: e,
        stackTrace: stacktrace,
      );
      return null;
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
}
