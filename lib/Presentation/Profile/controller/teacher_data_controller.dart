import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_teacher_app/Core/Utility/app_color.dart';
import 'package:st_teacher_app/Core/consents.dart';

import '../../../Core/Utility/snack_bar.dart';

import '../../../api/data_source/apiDataSource.dart';
import '../model/teacher_data_response.dart';

class TeacherDataController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<TeacherDataResponse?> teacherDataResponse = Rx<TeacherDataResponse?>(null);
  RxString frontImageUrl = ''.obs;
  ApiDataSource apiDataSource = ApiDataSource();

  @override
  void onInit() {
    super.onInit();
    getTeacherClassData();
  }

  final RxInt profileImgVersion = 0.obs;

  void applyNewProfileImage(String newUrl) {
    final resp = teacherDataResponse.value;
    if (resp != null) {
      resp.data.profile.profileImg = newUrl;
      // notify Obx listeners
      teacherDataResponse.refresh();
      // bump cache-buster
      profileImgVersion.value++;
    }
  }

  Future<String?> getTeacherClassData() async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.getTeacherClassData();
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          // Parse and assign the response data
          teacherDataResponse.value = response;

          AppLogger.log.i(response.data ?? 'Data fetched');
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<void> imageUpload({
    bool showLoader = true,
    File? frontImageFile,
  }) async {
    try {
      String? frontImageUrl;
      if (showLoader) showPopupLoader();
      if (frontImageFile != null) {
        final frontResult = await apiDataSource.userProfileUpload(
          imageFile: frontImageFile,
        );

        frontImageUrl = frontResult.fold((failure) {
          CustomSnackBar.showError("Front Upload Failed: ${failure.message}");
          return null;
        }, (success) => success.message);

        if (frontImageUrl == null) {
          isLoading.value = false;
          return;
        }
      } else {
        frontImageUrl = this.frontImageUrl.value;
      }
      final results = await apiDataSource.studentProfileInsert(
        image: frontImageUrl,
      );
      return results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
        },
        (response) async {
          await getTeacherClassData();
          if (showLoader) hidePopupLoader();
          Get.back();
          AppLogger.log.i(response);
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
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
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }

  void hidePopupLoader() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
