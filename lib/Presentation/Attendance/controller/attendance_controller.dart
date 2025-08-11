import 'package:get/get.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';

import '../model/class_list_response.dart';

class AttendanceController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxBool isLoading = false.obs;
  String accessToken = '';
  RxList<ClassData> classList = <ClassData>[].obs;

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
}
