import 'package:get/get.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';

import '../model/class_list_response.dart';

class AttendanceController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isPresentLoading = false.obs;
  String accessToken = '';
  RxList<ClassData> classList = <ClassData>[].obs;

  Rxn<AttendanceData> attendance = Rxn<AttendanceData>(); // <-- Added

  @override
  void onInit() {
    super.onInit();
    getClassList();
  }

  Future<String?> getClassList() async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.getClassList();
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;

          // Store in memory
          // classList.assignAll(response.data);
          classList.value = response.data ?? [];
          AppLogger.log.i(classList.toString());

          if (classList.isNotEmpty) {
            int firstClassId = classList.first.id ?? 0;
            await getTodayStatus(firstClassId);
          }
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('token', response.token);
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<AttendanceData?> getTodayStatus(
    int classId, {
    bool showLoader = true,
  }) async {
    try {
      if (showLoader) isLoading.value = true;

      final results = await apiDataSource.getTodayStatus(classId);
      return await results.fold(
        (failure) {
          if (showLoader) isLoading.value = false;
          AppLogger.log.e(failure.message);
          return null;
        },
        (response) async {
          if (showLoader) isLoading.value = false;
          attendance.value = response.data;
          return response.data;
        },
      );
    } catch (e) {
      if (showLoader) isLoading.value = false;
      AppLogger.log.e(e);
      return null;
    }
  }

  Future<bool> presentOrAbsent({
    required int studentId,
    required int classId,
    required String status,
  }) async {
    try {
      final results = await apiDataSource.presentOrAbsent(
        studentId: studentId,
        classId: classId,
        status: status,
      );
      return results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
          return false;
        },
        (response) async {
          AppLogger.log.i(response.toString());
          return true;
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('token', response.token);
        },
      );
    } catch (e) {
      AppLogger.log.e(e);
      return false;
    }
  }
}
