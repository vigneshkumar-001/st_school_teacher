import 'package:get/get.dart';

import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';

import '../model/attendence_student_history.dart';

class AttendanceStudentController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;
  RxBool isLoading = false.obs;

  String accessToken = '';
  Rx<AttendanceStudentData?> attendanceStudentHistory =
      Rx<AttendanceStudentData?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  Future<AttendanceStudentData?> fetchStudentAttendanceHistory({
    required int studentId,
    required DateTime date,
    required int classId,
    bool showLoader = true,
  }) async {
    try {
      if (showLoader) isLoading.value = true;

      final results = await apiDataSource.fetchStudentAttendanceHistory(
        studentId: studentId,
        classId: classId,
        date: date,
      );

      return await results.fold(
        (failure) {
          if (showLoader) isLoading.value = false;
          AppLogger.log.e(failure.message);
          return null;
        },
        (response) async {
          if (showLoader) isLoading.value = false;
          attendanceStudentHistory.value = response.data;

          return response.data;
        },
      );
    } catch (e) {
      if (showLoader) isLoading.value = false;
      AppLogger.log.e(e);
      return null;
    }
  }
}
