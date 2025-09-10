import 'package:dartz/dartz_unsafe.dart' as data;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../Core/Utility/app_color.dart';
import '../../../api/data_source/apiDataSource.dart';
import '../../Homework/model/teacher_class_response.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:st_teacher_app/Core/consents.dart';
import '../../../Core/Utility/snack_bar.dart';

class ExamController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();

  RxBool isLoading = false.obs;
  final RxList<String> categoryOptions = <String>[].obs;
  final RxBool isCategoryLoading = false.obs;
  final RxString categoryError = ''.obs;
  String accessToken = '';
  RxString frontImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
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
        },
        (response) async {
          if (showLoader) hidePopupLoader();
          AppLogger.log.i(response.message);
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
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
