import 'package:get/get.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/Presentation/Homework/model/teacher_class_response.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';
import 'package:st_teacher_app/Core/consents.dart';

class TeacherClassController extends GetxController {
  ApiDataSource apiDataSource = ApiDataSource();
  RxString currentLoadingStatus = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isPresentLoading = false.obs;
  String accessToken = '';
  RxList<TeacherClass> classList = <TeacherClass>[].obs;
  RxList<TeacherSubject> subjectList = <TeacherSubject>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTeacherClass();
  }

  Future<String?> getTeacherClass() async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.getTeacherClass();
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;

          classList.value = response.data.classes;
          subjectList.value = response.data.subjects;

          AppLogger.log.i("Fetched ${classList.length} classes");
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
