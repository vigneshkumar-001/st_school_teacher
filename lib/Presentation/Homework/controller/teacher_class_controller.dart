import 'package:get/get.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/Presentation/Homework/model/teacher_class_response.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'package:flutter/widgets.dart';

class TeacherClassController extends GetxController {
  final ApiDataSource apiDataSource = ApiDataSource();
  RxBool isLoading = false.obs;
  Rx<TeacherClass?> selectedClass = Rx<TeacherClass?>(null);

  RxList<TeacherClass> classList = <TeacherClass>[].obs;
  RxList<TeacherSubject> subjectList = <TeacherSubject>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTeacherClass();
  }


  Future<void> getTeacherClass({String? className, String? section}) async {
    try {
      isLoading.value = true;

      final results = await apiDataSource.getTeacherClass();
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) {
          classList.value = response.data.classes;
          subjectList.value = response.data.subjects;
          isLoading.value = false;

          // Set selected class based on passed className/section or default to first
          if (classList.isNotEmpty) {
            TeacherClass? selected;

            if (className != null && section != null) {
              selected = classList.firstWhereOrNull(
                (c) => c.name == className && c.section == section,
              );
            }

            selectedClass.value = selected ?? classList.first;

            AppLogger.log.i(
              "Selected class: ${selectedClass.value?.name} - ${selectedClass.value?.section}",
            );
          }

          AppLogger.log.i("Fetched ${classList.length} classes");
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
    }
  }
}

// import 'package:get/get.dart';
// import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
// import 'package:st_teacher_app/Presentation/Homework/model/teacher_class_response.dart';
// import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
// import 'package:st_teacher_app/Core/consents.dart';
// import 'package:flutter/widgets.dart';
//
// class TeacherClassController extends GetxController {
//   ApiDataSource apiDataSource = ApiDataSource();
//   RxString currentLoadingStatus = ''.obs;
//   RxBool isLoading = false.obs;
//   Rx<TeacherClass?> selectedClass = Rx<TeacherClass?>(null);
//
//   RxBool isPresentLoading = false.obs;
//   String accessToken = '';
//   RxList<TeacherClass> classList = <TeacherClass>[].obs;
//   RxList<TeacherSubject> subjectList = <TeacherSubject>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     getTeacherClass();
//   }
//
//   Future<String?> getTeacherClass() async {
//     try {
//       isLoading.value = true;
//       final results = await apiDataSource.getTeacherClass();
//       results.fold(
//         (failure) {
//           isLoading.value = false;
//           AppLogger.log.e(failure.message);
//         },
//         (response) async {
//           isLoading.value = false;
//
//           classList.value = response.data.classes;
//           subjectList.value = response.data.subjects;
//           if (classList.isNotEmpty) {
//             // Set default selected class after build
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               selectedClass.value = classList.first;
//               AppLogger.log.i(
//                 "Default selected class: ${classList.first.name} - ${classList.first.section}",
//               );
//             });
//           }
//
//           AppLogger.log.i("Fetched ${classList.length} classes");
//         },
//       );
//     } catch (e) {
//       isLoading.value = false;
//       AppLogger.log.e(e);
//       return e.toString();
//     }
//     return null;
//   }
// }
