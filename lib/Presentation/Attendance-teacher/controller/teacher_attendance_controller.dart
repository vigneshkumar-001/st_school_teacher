import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';

import '../../../Core/Utility/app_color.dart';
import '../model/teacher_attendance_response.dart';
import '../model/teacher_daily_attendance_response.dart';

class TeacherAttendanceController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isPresentLoading = false.obs;
  String accessToken = '';
  Rx<TeacherAttendanceResponse?> teacherAttendanceData =
      Rx<TeacherAttendanceResponse?>(null);

  Rx<TeacherDailyAttendanceData?> teacherDailyAttendanceData =
      Rx<TeacherDailyAttendanceData?>(null);
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getTeacherAttendanceMonth({
    required month,
    required year,
    bool showLoader = false,
  }) async {
    try {
      // isLoading.value = true;
      if (showLoader) showPopupLoader(); // show popup loader
      final results = await apiDataSource.getTeacherAttendanceMonth(
        month: month,
        year: year,
      );
      results.fold(
        (failure) {
          //isLoading.value = false;
          if (showLoader) hidePopupLoader(); // hide popup loader
          AppLogger.log.e(failure.message);
        },
        (response) async {
          //isLoading.value = false;
          if (showLoader) hidePopupLoader(); // hide popup loader
          teacherAttendanceData.value = response; // ✅ store full response
          AppLogger.log.i(response.message);
        },
      );
    } catch (e) {
      //isLoading.value = false;
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
    return null;
  }

  Future<TeacherDailyAttendanceData?> getTeacherDailyAttendance({
    required DateTime date,
    bool showLoader = true,
  }) async {
    try {
      if (showLoader) showPopupLoader(); // show popup loader
      final results = await apiDataSource.getTeacherDailyAttendance(date: date);
      results.fold(
        (failure) {
          if (showLoader) hidePopupLoader(); // hide popup loader
          AppLogger.log.e(failure.message);
          return null;
        },
        (response) async {
          if (showLoader) hidePopupLoader(); // hide popup loader
          teacherDailyAttendanceData.value = response.data;
          AppLogger.log.i(response.message);
          return response.data;
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader(); // hide popup loader
      AppLogger.log.e(e);
      return null;
    }
    return null;
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
