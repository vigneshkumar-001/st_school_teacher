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
  final RxBool isAttendanceLoading = false.obs;
  final RxBool isMarkingLoading = false.obs;
  String accessToken = '';
  RxList<ClassData> classList = <ClassData>[].obs;
  final RxList<Student> students = <Student>[].obs;
  Rxn<AttendanceData> attendance = Rxn<AttendanceData>(); // <-- Added

  RxBool isSubmitting = false.obs; // loader for submit button
  int get presentCount => students.where((s) => s.isPresent).length;
  int get absentCount => students.where((s) => !s.isPresent).length;

  void toggleSingle(int index) {
    students[index].isPresent = !students[index].isPresent;
    students.refresh(); // 🔑 Needed for UI update
  }

  void toggleSelectAll(bool value) {
    for (var s in students) {
      s.isPresent = value;
    }
    students.refresh(); // 🔑
  }

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
          AppLogger.log.i('Class Length${classList.length}');

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
      if (showLoader) isAttendanceLoading.value = true;

      final results = await apiDataSource.getTodayStatus(classId);

      return await results.fold(
        (failure) {
          AppLogger.log.e("Attendance error: ${failure.message}");
          return null;
        },
        (response) async {
          students.assignAll(response.data.students ?? []);
          attendance.value = response.data;

          AppLogger.log.i("Attendance fetched: ${students.length} students");
          return response.data;
        },
      );
    } catch (e) {
      AppLogger.log.e("Attendance exception: $e");
      return null;
    } finally {
      if (showLoader) isAttendanceLoading.value = false;
    }
  }

  Future<bool> submitBulkAttendance({
    required int classId,
    required List<Student> studentsList,
  }) async {
    try {
      isSubmitting.value = true;

      // Prepare items for API
      final items =
          studentsList.map((s) {
            return {
              "student_id": s.id,
              "status": s.isPresent ? "present" : "absent",
            };
          }).toList();

      // 🔹 Combine into the body as backend expects
      final body = {"class_id": classId, "items": items};

      // 🔹 Print the body
      AppLogger.log.i("Submitting bulk attendance: $body");
      print("Submitting bulk attendance: $body");

      // Call API
      final results = await apiDataSource.presentOrAbsentBulk(
        classId: classId,
        items: items,
      );

      return results.fold(
        (failure) {
          AppLogger.log.e(failure.message);
          return false;
        },
        (response) async {
          await getClassList();
          AppLogger.log.i("Bulk attendance submitted successfully");
          return true;
        },
      );
    } catch (e) {
      AppLogger.log.e(e);
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
