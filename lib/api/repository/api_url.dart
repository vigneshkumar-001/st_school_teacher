class ApiUrl {
  static String baseUrl = 'https://school-back-end-594f59bea6cb.herokuapp.com';

  static String login = '$baseUrl/teacher-auth/login';
  static String verifyOtp = '$baseUrl/teacher-auth/verify-otp';
  static String classList = '$baseUrl/teacher-student-attendance/class-list';
  static String attendance =
      '$baseUrl/teacher-student-attendance/mark-attendance';

  static String studentAttendance({required int classId}) {
    return '$baseUrl/teacher-student-attendance/today-status/?class_id=$classId';
  }

  static String attendanceByDate({
    required int classId,
    required String formattedDate,
  }) {
    return '$baseUrl/teacher-student-attendance/attendance-by-date?class_id=$classId&date=$formattedDate';
  }
}
