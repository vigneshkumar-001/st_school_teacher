import 'package:get/get.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import '../model/teacher_data_response.dart';

class TeacherDataController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<TeacherDataResponse?> teacherDataResponse = Rx<TeacherDataResponse?>(null);

  ApiDataSource apiDataSource = ApiDataSource();

  @override
  void onInit() {
    super.onInit();
    getTeacherClassData();
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
}
