import 'package:get/get.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendance_history_response.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';

class AttendanceHistoryController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;
  RxBool isLoading = false.obs;

  String accessToken = '';
  RxList<AttendanceHistoryData> attendanceHistoryList =
      <AttendanceHistoryData>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<AttendanceHistoryData?> fetchAttendance(
    DateTime date,
    int classId, {
    bool showLoader = true,
  }) async {
    try {
      if (showLoader) isLoading.value = true;

      final results = await apiDataSource.fetchAttendanceHistory(classId, date);
      return await results.fold(
        (failure) {
          if (showLoader) isLoading.value = false;
          AppLogger.log.e(failure.message);
          return null;
        },
        (response) async {
          if (showLoader) isLoading.value = false;

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
