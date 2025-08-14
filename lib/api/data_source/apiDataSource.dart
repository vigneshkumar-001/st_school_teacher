import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendance_history_response.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_student_history.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/class_list_response.dart';
import 'package:st_teacher_app/Presentation/Homework/model/get_homework_response.dart';
import 'package:st_teacher_app/Presentation/Homework/model/teacher_class_response.dart';
import 'package:st_teacher_app/api/repository/api_url.dart';

import '../../Presentation/Attendance/model/student_attendance_response.dart';
import '../../Presentation/Homework/model/homework_details_response.dart';
import '../../Presentation/Login Screen/model/login_response.dart';
import '../../Presentation/Profile/model/teacher_data_response.dart';
import '../repository/failure.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

import '../repository/request.dart';

abstract class BaseApiDataSource {
  Future<Either<Failure, LoginResponse>> mobileNumberLogin(String mobileNumber);
}

class ApiDataSource extends BaseApiDataSource {
  @override
  Future<Either<Failure, LoginResponse>> mobileNumberLogin(String phone) async {
    try {
      String url = ApiUrl.login;

      dynamic response = await Request.sendRequest(
        url,
        {"phone": phone},
        'Post',
        false,
      );
      AppLogger.log.i(response);
      if (response is! DioException && response.statusCode == 201) {
        if (response.data['status'] == true) {
          return Right(LoginResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, LoginResponse>> otpLogin({
    required String phone,
    required String otp,
  }) async {
    try {
      String url = ApiUrl.verifyOtp;

      dynamic response = await Request.sendRequest(
        url,
        {"otp": otp, "phone": phone},
        'Post',
        false,
      );
      AppLogger.log.i(response);
      if (response is! DioException && response.statusCode == 201) {
        if (response.data['status'] == true) {
          return Right(LoginResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, ClassListResponse>> getClassList() async {
    try {
      String url = ApiUrl.classList;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(ClassListResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, AttendanceResponse>> getTodayStatus(
    int classId,
  ) async {
    try {
      String url = ApiUrl.studentAttendance(classId: classId);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(AttendanceResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, LoginResponse>> presentOrAbsent({
    required int studentId,
    required int classId,
    required String status,
  }) async {
    try {
      String url = ApiUrl.attendance;

      dynamic response = await Request.sendRequest(
        url,
        {"student_id": studentId, "class_id": classId, "status": status},
        'Post',
        false,
      );
      AppLogger.log.i(response);
      if (response is! DioException && response.statusCode == 201) {
        if (response.data['status'] == true) {
          return Right(LoginResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, AttendanceHistoryResponse>> fetchAttendanceHistory(
    int classId,
    DateTime date,
  ) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      String url = ApiUrl.attendanceByDate(
        classId: classId,
        formattedDate: formattedDate,
      );

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(AttendanceHistoryResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, AttendanceStudentHistory>>
  fetchStudentAttendanceHistory({
    required int studentId,
    required int classId,
    required DateTime date,
  }) async {
    final month = date.month;
    final year = date.year;

    try {
      String url = ApiUrl.monthlyAttendanceByStudent(
        studentId: studentId,
        month: month,
        year: year,
        classId: classId,
      );

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(AttendanceStudentHistory.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, StudentAttendanceResponse>> studentDayAttendance({
    required int studentId,
    required int classId,
    required DateTime date,
  }) async {
    final formattedDate =
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    try {
      String url = ApiUrl.studentDayAttendance(
        classId: classId,
        date: formattedDate,
        studentId: studentId,
      );

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);

      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(StudentAttendanceResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, TeacherClassResponse>> getTeacherClass() async {
    try {
      String url = ApiUrl.teacherClassFetch;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(TeacherClassResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, LoginResponse>> createHomeWork({
    required int classId,
    required int subjectId,
    required String heading,
    required String description,
    required bool publish,
    required List<Map<String, dynamic>> contents,
  }) async {
    try {
      String url = ApiUrl.createHomework;

      final body = {
        "classId": classId,
        "subjectId": subjectId,
        "heading": heading,
        "description": description,
        "publish": publish,
        "contents": contents, // pass directly
      };

      dynamic response = await Request.sendRequest(url, body, 'Post', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(LoginResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, GetHomeworkResponse>> getHomeWork() async {
    try {
      String url = ApiUrl.getHomeWork;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(GetHomeworkResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, HomeworkDetails>> getHomeWorkDetails({
    int? classId,
  }) async {
    try {
      String url = ApiUrl.homeWorkDetails(classId: classId ?? 0);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(HomeworkDetails.fromJson(response.data['data']));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }

  Future<Either<Failure, TeacherDataResponse>> getTeacherClassData({
    int? classId,
  }) async {
    try {
      String url = ApiUrl.profile;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(TeacherDataResponse.fromJson(response.data));
        } else {
          return Left(ServerFailure(response.data['message']));
        }
      } else {
        return Left(ServerFailure((response as DioException).message ?? ""));
      }
    } catch (e) {
      return Left(ServerFailure(''));
    }
  }
}
