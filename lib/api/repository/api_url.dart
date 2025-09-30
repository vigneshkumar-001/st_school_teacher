class ApiUrl {
  static String baseUrl1 = 'https://school-back-end-594f59bea6cb.herokuapp.com';
  static String baseUrl =
      'https://school-backend-v2-19bebceab98e.herokuapp.com';
  static String teacherInfo = '$baseUrl/student-teacher-info';
  static String paymentHistory = '$baseUrl/student-payments/history';
  static String login = '$baseUrl/student-auth/login';
  static String changePhoneNumber = '$baseUrl/student/change-phone/request';
  static String verifyOtp = '$baseUrl/student-auth/verify-otp';
  static String changePhoneVerify = '$baseUrl/student/change-phone/verify';
  static String studentHome = '$baseUrl/student-home';
  static String classList = '$baseUrl/teacher-student-attendance/class-list';
  static String task = '$baseUrl/student-home/tasks?';
  static String announcementList = '$baseUrl/student-announcement/list';
  static String studentMessageList = '$baseUrl/student-messages/history';
  static String reactMessage = '$baseUrl/student-messages/create';
  static String profileImage =
      '$baseUrl/student-home/profiles/profile-image-url';

  static String examDetails({required int examId}) {
    return '$baseUrl/student-exams/$examId/details';
  }

  static String imageUrl =
      "https://next.fenizotechnologies.com/Adrox/api/image-save";
  static String attendance =
      '$baseUrl/teacher-student-attendance/mark-attendance';
  static String quizSubmit = '$baseUrl/student-quiz/submit';

  static String studentAttendance({required int classId}) {
    return '$baseUrl/teacher-student-attendance/today-status/?class_id=$classId';
  }

  static String profiles = '$baseUrl/student-home/profiles';

  static String switchSiblings({required int id}) {
    return '$baseUrl/student-home/profiles/switch/$id';
  }

  static String attendanceByDate({
    required int classId,
    required String formattedDate,
  }) {
    return '$baseUrl/teacher-student-attendance/attendance-by-date?class_id=$classId&date=$formattedDate';
  }

  static String QuizAttend({required int quizId}) {
    return '$baseUrl/student-quiz/take/$quizId';
  }

  static String announcementDetails({required int id}) {
    return '$baseUrl/student-announcement/details/$id';
  }

  static String QuizResult({required int quizId}) {
    return '$baseUrl/student-quiz/result/$quizId';
  }

  static String getHomeWorkIdDetails({required int id}) {
    return '$baseUrl/student-home/homework/$id';
  }

  static String getExamResultData({required int id}) {
    return '$baseUrl/student-exams/$id/result';
  }

  static String getAttendanceMonth({required int month, required int year}) {
    return '$baseUrl/student-home/monthly-attendance-by-student?year=$year&month=$month';
  }
}
