import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'package:st_teacher_app/Presentation/Home/home.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';

import '../otp_screen.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  String accessToken = '';
  RxBool isOtpLoading = false.obs;
  ApiDataSource apiDataSource = ApiDataSource();

  @override
  void onInit() {
    super.onInit();
  }

  Future<String?> mobileNumberLogin(String phone) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.mobileNumberLogin(phone);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          isLoading.value = false;
          accessToken = response.token;
          AppLogger.log.i(response.message);

          Get.to(() => OtpScreen(mobileNumber: phone, pages: 'splash'));
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> otpLogin({required String phone, required String otp}) async {
    try {
      isOtpLoading.value = true;
      final results = await apiDataSource.otpLogin(otp: otp, phone: phone);
      results.fold(
        (failure) {
          isOtpLoading.value = false;
          AppLogger.log.e(failure.message);
        },
        (response) async {
          Get.offAll(Home(pages: 'homeScreen'));
          isOtpLoading.value = false;
          AppLogger.log.i(response.message);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response.token);
          String? token = prefs.getString('token');
          AppLogger.log.i('token = $token');
        },
      );
    } catch (e) {
      isOtpLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }
}
