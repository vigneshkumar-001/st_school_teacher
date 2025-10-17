import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'package:st_teacher_app/Presentation/Announcement%20Screen/controller/announcement_contorller.dart';
import 'package:st_teacher_app/Presentation/Home/home.dart';
import 'package:st_teacher_app/Presentation/Login%20Screen/change_mobile_number.dart';
import 'package:st_teacher_app/api/data_source/apiDataSource.dart';

import '../../../Core/Utility/snack_bar.dart';
import '../../Attendance-teacher/controller/teacher_attendance_controller.dart';
import '../../Home/home_new_screen.dart';
import '../../Menu/menu_screen.dart';

import '../../Profile/controller/teacher_data_controller.dart';

import '../otp_screen.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  String accessToken = '';
  RxBool isOtpLoading = false.obs;
  ApiDataSource apiDataSource = ApiDataSource();
  final TeacherDataController controller = Get.put(TeacherDataController());
  final AnnouncementContorller announcementContorller = Get.put(
    AnnouncementContorller(),
  );
  final TeacherAttendanceController teacherAttendanceController = Get.put(
    TeacherAttendanceController(),
  );

  @override
  void onInit() {
    super.onInit();
  }

  Future<String?> sendFcmToken(String token) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.sendFcmToken(token: token);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          AppLogger.log.i('I Not sended Fcm Token To Api ');
        },
        (response) async {
          isLoading.value = false;
          AppLogger.log.i('I sended Fcm Token To Api ');

          AppLogger.log.i(response.message);
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> mobileNumberLogin(String phone) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.mobileNumberLogin(phone);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          CustomSnackBar.showError(failure.message);
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

  Future<String?> changeMobileNumberLogin(String phone) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.changeMobileNumberLogin(phone);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          isLoading.value = false;
          accessToken = response.token;

          AppLogger.log.i(response.message);

          Get.to(() => OtpScreen(mobileNumber: phone, pages: ''));
        },
      );
    } catch (e) {
      isLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }

  Future<String?> notificationUnregister(String token) async {
    try {
      isLoading.value = true;
      final results = await apiDataSource.notificationUnRegister(token);
      results.fold(
        (failure) {
          isLoading.value = false;
          AppLogger.log.e(failure.message);
          CustomSnackBar.showError(failure.message);
        },
        (response) async {
          isLoading.value = false;
          accessToken = response.token;

          AppLogger.log.i(response.message);
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
          CustomSnackBar.showError(failure.message);
          AppLogger.log.e(failure.message);
        },
        (response) async {
          // Home(pages: 'homeScreen', page: ''),

          // Get.offAll(Home(pages: 'homeScreen'));

          AppLogger.log.i(response.message);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response.token);
          String? token = prefs.getString('token');
          final _fcmToken = prefs.getString('fcmToken');
          sendFcmToken(_fcmToken!);
          await _loadInitialData();
          final now = DateTime.now();
          await teacherAttendanceController.getTeacherAttendanceMonth(
            month: now.month,
            year: now.year,
          );
          Get.offAll(HomeNewScreen(page: 'homeScreen'));
          isOtpLoading.value = false;
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

  Future<String?> changeNumberOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      isOtpLoading.value = true;
      final results = await apiDataSource.changeNumberOtp(
        otp: otp,
        phone: phone,
      );
      results.fold(
        (failure) {
          isOtpLoading.value = false;
          CustomSnackBar.showError(failure.message);
          AppLogger.log.e(failure.message);
        },
        (response) async {
          Get.offAll(HomeNewScreen(page: ''));
          // Home(pages: 'homeScreen', page: ''),

          // Get.offAll(Home(pages: 'homeScreen'));

          isOtpLoading.value = false;

          AppLogger.log.i(response.message);
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('token', response.token);
          // String? token = prefs.getString('token');
          // await controller.getTeacherClassData();
          // AppLogger.log.i('token = $token');
        },
      );
    } catch (e) {
      isOtpLoading.value = false;
      AppLogger.log.e(e);
      return e.toString();
    }
    return null;
  }


  Future<void> checkTokenExpire() async {
    try {
      final results = await apiDataSource.checkTokenExpire();
      results.fold(
            (failure) {
          AppLogger.log.e(failure.message);
        },
            (response) async {
          AppLogger.log.i(response.message);

          final prefs = await SharedPreferences.getInstance();

          // Only replace token if the API returned a new one
          if (response.token.isNotEmpty) {
            accessToken = response.token;
            await prefs.setString('token', accessToken);
            AppLogger.log.i('Token refreshed: $accessToken');
          } else {
            // Keep the existing token
            accessToken = prefs.getString('token') ?? '';
            AppLogger.log.i(
              'Token still valid, using existing token: $accessToken',
            );
          }


          await _loadInitialData();
        },
      );
    } catch (e) {
      AppLogger.log.e('Error checking token: $e');
    } finally {}
  }


  Future<void> _loadInitialData() async {
    await Future.wait([
      controller.getTeacherClassData(),
      announcementContorller.getCategoryList(showLoader: false),
      announcementContorller.getAnnouncement(showLoader: false),
    ]);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      accessToken = token;
      await _loadInitialData();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    accessToken = '';
    Get.offAll(() => ChangeMobileNumber(page: 'splash'));
  }
}
