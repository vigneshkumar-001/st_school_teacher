class ApiUrl {
  static String baseUrl = 'https://school-back-end-594f59bea6cb.herokuapp.com';


  static String login = '$baseUrl/teacher-auth/login';
  static String verifyOtp = '$baseUrl/teacher-auth/verify-otp';
  static String classList = '$baseUrl/teacher-student-attendance/class-list';

  /*  static String cancelRide({required String bookingId}) {
    return '$baseUrl/api/customer/cancel-booking/$bookingId';
  }*/
}
