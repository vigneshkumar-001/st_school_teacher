// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:st_teacher_app/Core/Utility/app_color.dart';
// import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
// import 'package:st_teacher_app/Presentation/Homework/homework_history.dart';
// import 'package:st_teacher_app/Presentation/Homework/model/homework_details_response.dart';
// import 'package:st_teacher_app/Presentation/Homework/model/teacher_class_response.dart';
// import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
// import 'package:st_teacher_app/Core/consents.dart';
//
// import '../../../Core/Utility/snack_bar.dart';
// import '../model/get_homework_response.dart';
//
// class CreateHomeworkController extends GetxController {
//   ApiDataSource apiDataSource = ApiDataSource();
//
//   RxBool isLoading = false.obs;
//
//   String accessToken = '';
//   RxString frontImageUrl = ''.obs;
//   var homeworkList = <Homework>[].obs;
//   Rxn<HomeworkDetails> homeworkDetails = Rxn<HomeworkDetails>();
//
//   var selectedClassName = 'All'.obs;
//   RxList<TeacherSubject> subjectList = <TeacherSubject>[].obs;
//   List<Map<String, dynamic>> contents = [];
//   var classNames = <String>[].obs;
//   @override
//   void onInit() {
//     super.onInit();
//     fetchHomeworks();
//   }
//
//   Future<void> createHomeWork({
//     int? classId,
//     int? subjectId,
//     String heading = '',
//     String description = '',
//     bool publish = false,
//     bool showLoader = true,
//     List<File>? imageFiles,
//     BuildContext? context,
//     required List<Map<String, dynamic>> contents,
//   }) async
//   {
//     try {
//       if (showLoader) showPopupLoader();
//
//       if (imageFiles != null && imageFiles.isNotEmpty) {
//         for (var file in imageFiles) {
//           final uploadResult = await apiDataSource.userProfileUpload(
//             imageFile: file,
//           );
//
//           String? imageUrl = uploadResult.fold((failure) {
//             CustomSnackBar.showError("Image Upload Failed: ${failure.message}");
//             return null;
//           }, (success) => success.message);
//
//           if (imageUrl != null) {
//             contents.add({"type": "image", "content": imageUrl});
//           }
//         }
//       }
//
//       final results = await apiDataSource.createHomeWork(
//         classId: classId ?? 0,
//         subjectId: subjectId ?? 0,
//         heading: heading,
//         description: description,
//         publish: publish,
//         contents: contents,
//       );
//
//       results.fold(
//         (failure) {
//           if (showLoader) hidePopupLoader();
//           AppLogger.log.e(failure.message);
//         },
//         (response) async {
//           fetchHomeworks();
//           if (showLoader) hidePopupLoader();
//           Navigator.pop(context!);
//           Navigator.pop(context!);
//           Get.to(HomeworkHistory());
//         },
//       );
//     } catch (e) {
//       if (showLoader) hidePopupLoader();
//       AppLogger.log.e(e);
//     }
//   }
//
//   Future<void> fetchHomeworks() async {
//     try {
//       isLoading.value = true;
//
//       final result = await apiDataSource.getHomeWork();
//
//       result.fold(
//         (failure) {
//           isLoading.value = false;
//           Get.snackbar('Error', failure.message);
//         },
//         (response) {
//           // Here, response is your GetHomeworkResponse object
//           final data =
//               response.data; // Correct: access 'data' from response object
//
//           final List<HomeworkItem > loadedHomework = [];
//
//           data.forEach((key, value) {
//             loadedHomework.addAll(value);
//             // value is already List<Homework>, no need to map again
//           });
//
//           homeworkList.value = loadedHomework;
//
//           // Build classNames dynamically from homeworkList
//           final classes =
//               loadedHomework.map((hw) => hw.classNames.trim()).toSet().toList()
//                 ..sort();
//
//           classNames.value = ['All', ...classes];
//
//           isLoading.value = false;
//         },
//       );
//     } catch (e) {
//       isLoading.value = false;
//       Get.snackbar('Error', e.toString());
//       AppLogger.log.e(e);
//     }
//   }
//
//   void selectClass(String className) {
//     selectedClassName.value = className;
//   }
//
//   List<HomeworkItem > get filteredHomework {
//     if (selectedClassName.value == 'All') {
//       return homeworkList;
//     }
//     return homeworkList
//         .where(
//           (hw) =>
//               hw.classNames.trim().toLowerCase() ==
//               selectedClassName.value.trim().toLowerCase(),
//         )
//         .toList();
//   }
//
//   Map<String, List<Homework>> get groupedHomeworkByDate {
//     Map<String, List<Homework>> grouped = {};
//
//     DateTime now = DateTime.now();
//     DateTime today = DateTime(now.year, now.month, now.day);
//     DateTime yesterday = today.subtract(Duration(days: 1));
//
//     List<Homework> filteredList = filteredHomework;
//
//     for (var hw in filteredList) {
//       DateTime hwDate = DateTime.parse(hw.date.toString() ?? '');
//       DateTime hwDateOnly = DateTime(hwDate.year, hwDate.month, hwDate.day);
//
//       String key;
//       if (hwDateOnly == today) {
//         key = 'Today';
//       } else if (hwDateOnly == yesterday) {
//         key = 'Yesterday';
//       } else {
//         key = DateFormat('MMM d, yyyy').format(hwDateOnly);
//       }
//
//       if (grouped.containsKey(key)) {
//         grouped[key]!.add(hw);
//       } else {
//         grouped[key] = [hw];
//       }
//     }
//
//     return grouped;
//   }
//
//   void showPopupLoader() {
//     Get.dialog(
//       Center(
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CircularProgressIndicator(
//               color: AppColor.black,
//               strokeAlign: 1,
//             ),
//           ),
//         ),
//       ),
//       barrierDismissible: false, // user can't dismiss by tapping outside
//       barrierColor: Colors.black.withOpacity(0.3), // transparent background
//     );
//   }
//
//   void hidePopupLoader() {
//     if (Get.isDialogOpen ?? false) {
//       Get.back();
//     }
//   }
//
//   Future<String?> getHomeWorkDetails({
//     int? classId,
//
//     bool showLoader = true,
//   }) async {
//     try {
//       homeworkDetails.value = null;
//       if (showLoader) showPopupLoader(); // show popup loader
//       final results = await apiDataSource.getHomeWorkDetails(
//         classId: classId ?? 0,
//       );
//       results.fold(
//         (failure) {
//           AppLogger.log.e(failure.message);
//         },
//         (response) async {
//           if (showLoader) hidePopupLoader();
//           homeworkDetails.value = response;
//         },
//       );
//     } catch (e) {
//       if (showLoader) hidePopupLoader();
//       AppLogger.log.e(e);
//       return e.toString();
//     }
//     return null;
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:st_teacher_app/Core/Utility/app_color.dart';
import 'package:st_teacher_app/Core/Utility/snack_bar.dart';
import 'package:st_teacher_app/Core/consents.dart';

import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/Presentation/Homework/homework_history.dart';
import 'package:st_teacher_app/Presentation/Homework/model/homework_details_response.dart';
import 'package:st_teacher_app/Presentation/Homework/model/teacher_class_response.dart';

import 'package:st_teacher_app/api/data_source/apiDataSource.dart';

import '../model/get_homework_response.dart';

class CreateHomeworkController extends GetxController {
  final ApiDataSource apiDataSource = ApiDataSource();

  final RxBool isLoading = false.obs;

  String accessToken = '';
  final RxString frontImageUrl = ''.obs;

  /// Flat list used by your UI and "No Homework Found" check
  final RxList<HomeworkItem> homeworkList = <HomeworkItem>[].obs;

  final Rxn<HomeworkDetails> homeworkDetails = Rxn<HomeworkDetails>();

  /// Chip state
  final RxString selectedClassName = 'All'.obs;
  final RxList<TeacherSubject> subjectList = <TeacherSubject>[].obs;
  final RxList<String> classNames = <String>[].obs;

  /// If you also need to keep a copy of raw groups from server:
  Map<String, List<HomeworkItem>> _rawGroups = const {};

  /// Optional scratch content buffer
  List<Map<String, dynamic>> contents = [];

  @override
  void onInit() {
    super.onInit();
    fetchHomeworks();
  }

  Future<void> createHomeWork({
    int? classId,
    int? subjectId,
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

      // Upload images first and push to contents
      if (imageFiles != null && imageFiles.isNotEmpty) {
        for (final file in imageFiles) {
          final uploadResult = await apiDataSource.userProfileUpload(
            imageFile: file,
          );

          final String? imageUrl = uploadResult.fold((failure) {
            CustomSnackBar.showError("Image Upload Failed: ${failure.message}");
            return null;
          }, (success) => success.message);

          if (imageUrl != null) {
            contents.add({"type": "image", "content": imageUrl});
          }
        }
      }

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
          if (showLoader) hidePopupLoader();
          AppLogger.log.e(failure.message);
        },
        (response) async {
          await fetchHomeworks();
          if (showLoader) hidePopupLoader();
          if (context != null) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
          Get.to(() => HomeworkHistory());
        },
      );
    } catch (e) {
      if (showLoader) hidePopupLoader();
      AppLogger.log.e(e);
    }
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
          // ✅ response is GetHomeworkResponse
          final Map<String, List<HomeworkItem>> groups = response.data.groups;

          // keep raw groups (if you later need Today/Yesterday from server)
          _rawGroups = groups;

          // flatten groups into one list for simple list usage
          final flat = <HomeworkItem>[];
          for (final list in groups.values) {
            flat.addAll(list);
          }
          homeworkList.assignAll(flat);

          // build class chips
          final classes =
              flat
                  .map((hw) => hw.classNames.trim())
                  .where((s) => s.isNotEmpty)
                  .toSet()
                  .toList()
                ..sort();
          classNames.assignAll(['All', ...classes]);

          isLoading.value = false;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
      AppLogger.log.e(e);
    }
  }

  void selectClass(String className) {
    selectedClassName.value = className;
  }

  /// Filtered list for the current chip selection
  List<HomeworkItem> get filteredHomework {
    if (selectedClassName.value == 'All') {
      return homeworkList.toList();
    }
    final sel = selectedClassName.value.trim().toLowerCase();
    return homeworkList
        .where((hw) => hw.classNames.trim().toLowerCase() == sel)
        .toList();
  }

  /// UI-friendly grouping (Today / Yesterday / Date) based on local time
  Map<String, List<HomeworkItem>> get groupedHomeworkByDate {
    final Map<String, List<HomeworkItem>> grouped = {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final List<HomeworkItem> items = filteredHomework;

    for (final hw in items) {
      final hwDate = hw.date; // already parsed to DateTime in model
      final hwDay = DateTime(hwDate.year, hwDate.month, hwDate.day);

      String key;
      if (hwDay == today) {
        key = 'Today';
      } else if (hwDay == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('MMM d, yyyy').format(hwDay);
      }

      (grouped[key] ??= <HomeworkItem>[]).add(hw);
    }

    return grouped;
  }

  // --- Popup loader helpers ---

  void showPopupLoader() {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
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

  Future<String?> getHomeWorkDetails({
    int? classId,
    bool showLoader = true,
  }) async {
    try {
      homeworkDetails.value = null;
      if (showLoader) showPopupLoader();

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
