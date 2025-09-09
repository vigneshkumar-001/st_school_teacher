import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:st_teacher_app/Core/consents.dart';
import 'package:st_teacher_app/Presentation/Attendance-teacher/model/teacher_attendance_response.dart';
import 'package:st_teacher_app/Presentation/Attendance-teacher/model/teacher_daily_attendance_response.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendance_history_response.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_response.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/attendence_student_history.dart';
import 'package:st_teacher_app/Presentation/Attendance/model/class_list_response.dart';
import 'package:st_teacher_app/Presentation/Homework/model/get_homework_response.dart';
import 'package:st_teacher_app/Presentation/Homework/model/teacher_class_response.dart';
import 'package:st_teacher_app/Presentation/Quiz%20Screen/quiz_history.dart';
import 'package:st_teacher_app/api/repository/api_url.dart';

import '../../Presentation/Announcement Screen/Model/announcement_create_response.dart';
import '../../Presentation/Announcement Screen/Model/announcement_list_general.dart';
import '../../Presentation/Attendance/model/student_attendance_response.dart';
import '../../Presentation/Homework/model/homework_details_response.dart';
import '../../Presentation/Homework/model/user_image_response.dart';
import '../../Presentation/Login Screen/model/login_response.dart';
import '../../Presentation/Profile/model/teacher_data_response.dart';
import '../../Presentation/Quiz Screen/Model/details_preview.dart';
import '../../Presentation/Quiz Screen/Model/history_specific_student_response.dart';
import '../../Presentation/Quiz Screen/Model/quiz_attend_response.dart';
import '../../Presentation/Quiz Screen/Model/quizlist_response.dart';
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
      if (response is! DioException) {
        // If status code is success
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(LoginResponse.fromJson(response.data));
          } else {
            return Left(
              ServerFailure(response.data['message'] ?? "Login failed"),
            );
          }
        } else {
          // ❗ API returned non-success code but has JSON error message
          return Left(
            ServerFailure(response.data['message'] ?? "Something went wrong"),
          );
        }
      }
      // Is DioException
      else {
        final errorData = response.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          return Left(ServerFailure(errorData['message']));
        }
        return Left(ServerFailure(response.message ?? "Unknown Dio error"));
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
      if (response is! DioException) {
        // If status code is success
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(LoginResponse.fromJson(response.data));
          } else {
            return Left(
              ServerFailure(response.data['message'] ?? "Login failed"),
            );
          }
        } else {
          // ❗ API returned non-success code but has JSON error message
          return Left(
            ServerFailure(response.data['message'] ?? "Something went wrong"),
          );
        }
      }
      // Is DioException
      else {
        final errorData = response.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          return Left(ServerFailure(errorData['message']));
        }
        return Left(ServerFailure(response.message ?? "Unknown Dio error"));
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

  Future<Either<Failure, TeacherAttendanceResponse>> getTeacherAttendanceMonth({
    required int month,
    required int year,
  }) async {
    try {
      String url = ApiUrl.getAttendanceMonth(month: month, year: year);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(TeacherAttendanceResponse.fromJson(response.data));
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

  Future<Either<Failure, TeacherDailyAttendanceResponse>>
  getTeacherDailyAttendance({required DateTime date}) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      String url = ApiUrl.getTeacherDailyAttendance(
        formattedDate: formattedDate,
      );

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(TeacherDailyAttendanceResponse.fromJson(response.data));
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

  Future<Either<Failure, UserImageModels>> userProfileUpload({
    required File imageFile,
  }) async {
    try {
      if (!await imageFile.exists()) {
        return Left(ServerFailure('Image file does not exist.'));
      }

      String url = ApiUrl.imageUrl;
      FormData formData = FormData.fromMap({
        'images': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await Request.formData(url, formData, 'POST', true);
      Map<String, dynamic> responseData =
          jsonDecode(response.data) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          return Right(UserImageModels.fromJson(responseData));
        } else {
          return Left(ServerFailure(responseData['message']));
        }
      } else if (response is Response && response.statusCode == 409) {
        return Left(ServerFailure(responseData['message']));
      } else if (response is Response) {
        return Left(ServerFailure(responseData['message'] ?? "Unknown error"));
      } else {
        return Left(ServerFailure("Unexpected error"));
      }
    } catch (e) {
      // CommonLogger.log.e(e);
      print(e);
      return Left(ServerFailure('Something went wrong'));
    }
  }

  Future<Either<Failure, QuizDetailsPreview>> quizCreate(
    Map<String, dynamic> body,
  ) async {
    try {
      String url = ApiUrl.teacherQuizCreate;

      final response = await Request.sendRequest(url, body, 'post', true);

      // If response is Dio Response
      if (response is Response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data['status'] == true) {
            return Right(QuizDetailsPreview.fromJson(response.data));
          } else {
            return Left(
              ServerFailure(response.data['message'] ?? "Unknown error"),
            );
          }
        } else {
          return Left(
            ServerFailure("Unexpected status: ${response.statusCode}"),
          );
        }
      }

      // If response is DioException
      if (response is DioException) {
        return Left(ServerFailure(response.message ?? "Request failed"));
      }

      // If neither
      return Left(
        ServerFailure("Unexpected response type: ${response.runtimeType}"),
      );
    } catch (e, stack) {
      AppLogger.log.e("quizCreate error: $e\n$stack");
      return Left(ServerFailure(e.toString()));
    }
  }

  // Future<Either<Failure, QuizListResponse>> quizList() async {
  //   try {
  //     String url = ApiUrl.teacherQuizList;
  //
  //     dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
  //     AppLogger.log.i(response);
  //     if (response is! DioException &&
  //         (response.statusCode == 200 || response.statusCode == 201)) {
  //       if (response.data['status'] == true) {
  //         return Right(QuizListResponse.fromJson(response.data));
  //       } else {
  //         return Left(ServerFailure(response.data['message']));
  //       }
  //     } else {
  //       return Left(ServerFailure((response as DioException).message ?? ""));
  //     }
  //   } catch (e) {
  //     return Left(ServerFailure(''));
  //   }
  // }

  Future<Either<Failure, QuizListResponse>> quizList() async {
    try {
      String url = ApiUrl.teacherQuizList;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);

      // DEBUG: Log the raw response string
      AppLogger.log.i('RAW RESPONSE: ${response.toString()}');
      AppLogger.log.i('Response length: ${response.toString().length}');

      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          // Check if data is complete
          String jsonString = json.encode(response.data);
          AppLogger.log.i('JSON string length: ${jsonString.length}');

          if (response.data['status'] == true) {
            try {
              return Right(QuizListResponse.fromJson(response.data));
            } catch (e) {
              AppLogger.log.e('JSON parsing error: $e');
              return Left(ServerFailure('Failed to parse quiz data'));
            }
          } else {
            return Left(
              ServerFailure(response.data['message'] ?? 'Unknown error'),
            );
          }
        } else {
          return Left(ServerFailure('Invalid response format'));
        }
      } else {
        String errorMessage =
            (response is DioException)
                ? response.message ?? "Network error"
                : "Request failed with status: ${response.statusCode}";
        return Left(ServerFailure(errorMessage));
      }
    } catch (e) {
      AppLogger.log.e('Quiz list error: $e');
      return Left(ServerFailure('Failed to fetch quiz list'));
    }
  }

  Future<Either<Failure, QuizDetailsPreview>> quizDetailsPreviews({
    required int code,
  }) async {
    try {
      String url = ApiUrl.quizDetailsPreview(classId: code);

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(QuizDetailsPreview.fromJson(response.data));
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

  Future<Either<Failure, AttendSummaryResponse>> loadQuizAttendByClass({
    required int quizId,
  }) async {
    try {
      final url = ApiUrl.teacherQuizAttend(classId: quizId);

      // 👇 Correct: use sendRequest with POST
      final resp = await Request.sendRequest(url, {}, 'POST', true);

      if (resp is Response) {
        final status = resp.statusCode ?? 0;

        if (status >= 200 && status < 300) {
          try {
            final parsed = AttendSummaryResponse.fromAny(resp.data);
            if (parsed.status) return Right(parsed);

            return Left(
              ServerFailure(
                parsed.message.isNotEmpty ? parsed.message : 'Request failed',
                code: parsed.code,
                data: resp.data,
              ),
            );
          } catch (e) {
            return Left(ServerFailure('Failed to parse attend summary: $e'));
          }
        }

        // Non-2xx: surface a meaningful server message if present
        final data = resp.data;
        String serverMsg = 'HTTP $status';
        if (data is Map && data['message'] != null) {
          serverMsg = data['message'].toString();
        }
        return Left(ServerFailure(serverMsg, code: status, data: data));
      }

      if (resp is DioException) {
        final code = resp.response?.statusCode;
        final data = resp.response?.data;
        String msg = resp.message ?? 'Network error';
        if (data is Map && data['message'] != null) {
          msg = data['message'].toString();
        }
        return Left(ServerFailure(msg, code: code, data: data));
      }

      AppLogger.log.e('Unexpected response type: ${resp.runtimeType}');
      return Left(
        ServerFailure('Unexpected response type: ${resp.runtimeType}'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, StudentQuizResult>> studentQuizResults({
    required int quizId,
    required int studentId,
  }) async {
    try {
      final url = ApiUrl.studentQuizResult(
        quizId: quizId,
        studentId: studentId,
      );
      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(StudentQuizResult.fromJson(response.data));
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

  Future<Either<Failure, AnnouncementCreateResponse>> createAnnouncement({
    required int classId,

    required String heading,
    required String category,
    required String announcementCategory,
    required String description,

    required List<Map<String, dynamic>> contents,
  }) async {
    try {
      String url = ApiUrl.createAnnouncement;

      final body = {
        "classId": classId,
        "category": category,
        "announcementCategory": announcementCategory,
        "title": heading,
        "content": description,

        "contents": contents, // pass directly
      };

      dynamic response = await Request.sendRequest(url, body, 'Post', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(AnnouncementCreateResponse.fromJson(response.data));
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

  Future<Either<Failure, AnnouncementListResponse>> listAnnouncement() async {
    try {
      String url = ApiUrl.listAnnouncement;

      dynamic response = await Request.sendGetRequest(url, {}, 'get', true);
      AppLogger.log.i(response);
      if (response is! DioException &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data['status'] == true) {
          return Right(AnnouncementListResponse.fromJson(response.data));
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
