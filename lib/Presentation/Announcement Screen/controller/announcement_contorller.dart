import 'package:dartz/dartz_unsafe.dart' as data;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:st_teacher_app/Presentation/Announcement%20Screen/Model/category_list_response.dart';
import '../../../Core/Utility/app_color.dart';
import '../../../api/data_source/apiDataSource.dart';
import '../../Homework/model/teacher_class_response.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:st_teacher_app/Core/consents.dart';
import '../../../Core/Utility/snack_bar.dart';
import '../Model/announcement_create_response.dart';
import '../Model/announcement_details_response.dart';
import '../Model/announcement_list_general.dart';
import '../announcement_screen.dart';

class AnnouncementContorller extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxList<Announcement> classList = <Announcement>[].obs;
  Rx<AnnouncementDetails?> announcementDetails = Rx<AnnouncementDetails?>(null);
  var categoryData = <CategoryData>[].obs;

  RxBool isLoading = false.obs;
  final RxList<String> categoryOptions = <String>[].obs;
  final RxBool isCategoryLoading = false.obs;
  final RxString categoryError = ''.obs;
  String accessToken = '';
  RxString frontImageUrl = ''.obs;

  Rx<AnnouncementData?> announcementData = Rx<AnnouncementData?>(null);

  var selectedClassName = 'All'.obs;
  RxList<Announcement> subjectList = <Announcement>[].obs;
  List<Map<String, dynamic>> contents = [];
  // var classNames = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    getAnnouncement();
  }

  final RxString error = ''.obs;
  final RxList<AnnouncementItem> items = <AnnouncementItem>[].obs;

  // pagination (optional)
  final RxInt page = 1.obs;
  final int limit = 20;
  final RxInt totalPages = 1.obs;

  /// Build class names like: ['All', '38', '39', ...]
  List<String> get classNames {
    final cls = items.map((e) => e.classId.toString()).toSet().toList()..sort();
    return ['All', ...cls];
  }

  final detail = Rxn<AnnouncementDetails>();

  Future<AnnouncementDetails?> getAnnouncementDetails({
    bool showLoader = true,
    required int id,
  }) async {
    try {
      if (showLoader) showPopupLoader();

      final results = await apiDataSource.announcementDetail(id);

      return results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
          return null;
        },
        (response) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.i('Announcement Details Fetched ✅');
          announcementDetails.value = response.data; // store in observable
          return response.data; // return data for UI
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
      return null;
    }
  }

  Future<void> createAnnouncement({
    int? classId,
    int? subjectId,
    String category = '',
    required int announcementCategoryId,
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
        announcementCategoryId: announcementCategoryId,
        description: description,

        contents: contents,
      );

      results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
        },
        (response) async {
          await getAnnouncement(type: 'general');
          if (showLoader) hidePopupLoader();
          Navigator.pop(context!);

          Get.off(AnnouncementScreen());
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
  }

  Future<String?> getAnnouncement({
    String type = "general",
    bool showLoader = true,
  }) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.getAnnouncementList(type: type);
      return results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          announcementData.value = response.data;
          AppLogger.log.i("announcementData List for $type");
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
    }
    return null;
  }

  Future<void> fetch(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Adjust the API call name/signature to your project.
      final result = await apiDataSource.announcementDetail(id);

      result.fold(
        (failure) {
          error.value = failure.message ?? 'Something went wrong';
          AppLogger.log.e(error.value);
        },
        (resp) {
          final data = resp.data;
          detail.value = data;
          contents.assignAll(
            (data?.contents ?? const []) as Iterable<Map<String, dynamic>>,
          );
          AppLogger.log.i('Loaded announcement detail: ${detail.value?.id}');
        },
      );
    } catch (e) {
      error.value = e.toString();
      AppLogger.log.e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<CategoryData>?> getCategoryList({bool showLoader = true}) async {
    try {
      if (showLoader) showPopupLoader();

      final results = await apiDataSource.getCategoryList();

      return results.fold(
        (failure) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
          return null;
        },
        (response) {
          if (showLoader) hidePopupLoader();
          AppLogger.log.i('Announcement Details Fetched ✅');
          categoryData.value = response.data;
          AppLogger.log.i(response.data);
          return response.data; // return data for UI
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
      return null;
    }
  }

  void clear() {
    isLoading.value = false;
    error.value = '';
    detail.value = null;
    contents.clear();
  }

  void selectClass(String className) {
    selectedClassName.value = className;
  }

  /*  List<Announcement> get filteredAnnouncement {
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

  Map<String, dynamic> _asMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    try {
      // If your response has toJson()
      // ignore: avoid_dynamic_calls
      final m = response.toJson() as Map<String, dynamic>;
      return m;
    } catch (_) {
      throw StateError('Unsupported response type: ${response.runtimeType}');
    }
  }*/
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
