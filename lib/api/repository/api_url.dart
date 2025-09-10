class ApiUrl {
  static String baseUrl = 'https://school-back-end-594f59bea6cb.herokuapp.com';
  static String baseUrl1 = 'https://9kt7pzw3-4000.inc1.devtunnels.ms';

  static String login = '$baseUrl/teacher-auth/login';
  static String changePhone = '$baseUrl/teacher/change-phone/request';
  static String verifyOtp = '$baseUrl/teacher-auth/verify-otp';
  static String changePhoneVerify = '$baseUrl/teacher/change-phone/verify';
  static String classList = '$baseUrl/teacher-student-attendance/class-list';
  static String teacherClassFetch = '$baseUrl/teacher-homework/meta';
  static String getHomeWork = '$baseUrl/teacher-homework/list';
  static String createHomework = '$baseUrl/teacher-homework/create';
  static String profileImageUrl = '$baseUrl/teacher-home/profiles/profile-image-url';
  static String profile = '$baseUrl/teacher-home/profile';
  static String teacherQuizCreate = '$baseUrl/teacher-quiz/create';
  static String teacherQuizList = '$baseUrl/teacher-quiz/list';
  static String createAnnouncement = '$baseUrl/teacher-announcement/create';
  static String teacherExamsCreate = '$baseUrl/teacher-exams/create';
  // static String listAnnouncement = '$baseUrl/teacher-announcement/list?=teacher  general';
  static String categoriesList = '$baseUrl/announcement-categories';

  static String announcementDetail({required int Id}) {
    return '$baseUrl/teacher-announcement/details/$Id';
  }

  static String listAnnouncement({required String type}) {
    return '$baseUrl/teacher-announcement/list?tab=$type';
  }

  static String studentQuizResult({
    required int quizId,
    required int studentId,
  }) => '$baseUrl/teacher-quiz/attend/$quizId/student/$studentId';

  static String teacherQuizAttend({required int classId}) =>
      '$baseUrl/teacher-quiz/attend/$classId';

  static String attendance =
      '$baseUrl/teacher-student-attendance/mark-attendance';

  static String studentAttendance({required int classId}) {
    return '$baseUrl/teacher-student-attendance/today-status/?class_id=$classId';
  }

  static String quizDetailsPreview({required int classId}) {
    return '$baseUrl/teacher-quiz/details/$classId';
  }

  static String attendanceByDate({
    required int classId,
    required String formattedDate,
  }) {
    return '$baseUrl/teacher-student-attendance/attendance-by-date?class_id=$classId&date=$formattedDate';
  }

  static String monthlyAttendanceByStudent({
    required int studentId,
    required int month,
    required int year,
    required int classId,
  }) {
    return '$baseUrl/teacher-student-attendance/monthly-attendance-by-student?student_id=$studentId&month=$month&year=$year&class_id=$classId';
  }

  static String studentDayAttendance({
    required int classId,
    required String date,
    required int studentId,
  }) {
    return '$baseUrl/teacher-student-attendance/student-day-attendance?class_id=$classId&date=$date&student_id=$studentId';
  }

  static String homeWorkDetails({required int classId}) {
    return '$baseUrl/teacher-homework/details/$classId';
  }

  static String getAttendanceMonth({required int month, required int year}) {
    return '$baseUrl/teacher-home/attendance?month=$month&year=$year';
  }

  static String getTeacherDailyAttendance({required String formattedDate}) {
    return '$baseUrl/teacher-home/attendance/daily?date=$formattedDate';
  }

  static String imageUrl =
      "https://next.fenizotechnologies.com/Adrox/api/image-save";
}
