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
import '../Model/announcement_create_response.dart';
import '../list_general.dart';

class AnnouncementContorller extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxList<Announcement> classList = <Announcement>[].obs;

  RxBool isLoading = false.obs;
  final RxList<String> categoryOptions = <String>[].obs;
  final RxBool isCategoryLoading = false.obs;
  final RxString categoryError = ''.obs;
  String accessToken = '';
  RxString frontImageUrl = ''.obs;
  var AnnouncementList = <Announcement>[].obs;

  var selectedClassName = 'All'.obs;
  RxList<Announcement> subjectList = <Announcement>[].obs;
  List<Map<String, dynamic>> contents = [];
  var classNames = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    listAnnouncement();
  }

  /*  Future<void> createAnnouncement({
    int? classId,
    int? subjectId,
    String category = '',
    String heading = '',
    String description = '',
    bool publish = false,
    bool showLoader = true,
    List<File>? imageFiles,
    BuildContext? context,
    required List<Map<String, dynamic>> contents,
  }) async {
    try {
      if (showLoader) showPopupLoader();

      if (imageFiles != null && imageFiles.isNotEmpty) {
        for (var file in imageFiles) {
          final uploadResult = await apiDataSource.userProfileUpload(
            imageFile: file,
          );

          String? imageUrl = uploadResult.fold((failure) {
            CustomSnackBar.showError("Image Upload Failed: ${failure.message}");
            return null;
          }, (success) => success.message);

          if (imageUrl != null) {
            contents.add({"type": "image", "content": imageUrl});
          }
        }
      }

      final results = await apiDataSource.createAnnouncement(
        classId: classId ?? 0,
        subjectId: subjectId ?? 0,
        heading: heading,
        category: category,
        description: description,
        publish: publish,
        contents: contents,
      );

      results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
        },
        (response) async {
          // fetchAnnouncement();
          if (showLoader) hidePopupLoader();
          Navigator.pop(context!);
          Navigator.pop(context!);
          // Get.to(HomeworkHistory());
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
  }*/

  Future<void> createAnnouncement({
    int? classId,
    int? subjectId,
    String category = '',
    String announcementCategory = '',
    String heading = '',
    String description = '',
    bool publish = false,
    bool showLoader = true,
    List<File>? imageFiles,
    BuildContext? context,
    required List<Map<String, dynamic>> contents,
  }) async {
    try {
      if (showLoader) showPopupLoader();

      // ✅ clone so we don't mutate the original list the UI built

      if (imageFiles != null && imageFiles.isNotEmpty) {
        for (var file in imageFiles) {
          final uploadResult = await apiDataSource.userProfileUpload(
            imageFile: file,
          );

          String? imageUrl = uploadResult.fold((failure) {
            CustomSnackBar.showError("Image Upload Failed: ${failure.message}");
            return null;
          }, (success) => success.message);

          if (imageUrl != null) {
            contents.add({"type": "image", "content": imageUrl});
          }
        }
      }

      final results = await apiDataSource.createAnnouncement(
        classId: classId ?? 0,

        heading: heading,
        category: category,
        announcementCategory: announcementCategory,
        description: description,

        contents: contents,
      );

      results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
        },
        (response) async {
          if (showLoader) hidePopupLoader();
          Navigator.pop(context!);
          Get.off(ListGeneral());
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
  }

  Future<void> listAnnouncement() async {
    try {
      isLoading.value = true;

      final result = await apiDataSource.listAnnouncement();

      result.fold(
        (failure) {
          isLoading.value = false;
          Get.snackbar('Error', failure.message);
        },
        (response) {
          // Here, response is your GetHomeworkResponse object
          final data =
              response.data; // Correct: access 'data' from response object

          final List<Announcement> loadedHomework = [];

          // data.forEach((key, value) {
          //   loadedHomework.addAll(value);
          //   // value is already List<Homework>, no need to map again
          // });
          AnnouncementList.value = loadedHomework;
          classList.value = loadedHomework;

          // Build classNames dynamically from homeworkList
          final classes =
              loadedHomework.map((ac) => ac.classId.toString()).toSet().toList()
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

  List<Announcement> get filteredAnnouncement {
    if (selectedClassName.value == 'All') {
      return AnnouncementList;
    }
    return AnnouncementList.where(
      (ac) =>
          ac.classId.toString().toLowerCase() ==
          selectedClassName.value.trim().toLowerCase(),
    ).toList();
  }

  Map<String, List<Announcement>> get groupedAnnouncementByDate {
    Map<String, List<Announcement>> grouped = {};

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    List<Announcement> filteredList = filteredAnnouncement;

    for (var ac in filteredList) {
      DateTime acDate = DateTime.parse(ac.category.toString() ?? '');
      DateTime acDateOnly = DateTime(acDate.year, acDate.month, acDate.day);

      String key;
      if (acDateOnly == today) {
        key = 'Today';
      } else if (acDateOnly == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMM d, yyyy').format(acDateOnly);
      }

      if (grouped.containsKey(key)) {
        grouped[key]!.add(ac);
      } else {
        grouped[key] = [ac];
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
}
