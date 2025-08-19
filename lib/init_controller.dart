import 'package:get/get.dart';
import 'package:st_teacher_app/Presentation/Attendance/controller/attendance_history_controller.dart';
import 'package:st_teacher_app/Presentation/Attendance/controller/student_attendence_controller.dart';
import 'package:st_teacher_app/Presentation/Homework/controller/teacher_class_controller.dart';
import 'package:st_teacher_app/Presentation/Login%20Screen/controller/login_controller.dart';

import 'Presentation/Attendance/controller/attendance_controller.dart';

Future<void>  initController() async {
  Get.lazyPut(() => LoginController());
  Get.lazyPut(() => AttendanceController());
  Get.lazyPut(() => AttendanceHistoryController());
  Get.lazyPut(() => StudentAttendanceController());
  Get.lazyPut(() => TeacherClassController());
}
