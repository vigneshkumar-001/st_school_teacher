class TeacherDailyAttendanceResponse {
  final bool status;
  final String message;
  final TeacherDailyAttendanceData? data;

  TeacherDailyAttendanceResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory TeacherDailyAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return TeacherDailyAttendanceResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? TeacherDailyAttendanceData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class TeacherDailyAttendanceData {
  final int teacherId;
  final String teacherName;
  final String date;
  final String morning;
  final String afternoon;
  final bool fullDayPresent;
  final bool fullDayAbsent;
  final bool holidayStatus;
  final bool eventsStatus;
  final bool isNullStatus;
  final String? eventTitle;
  final String? eventImage;
  final String monthName;
  final int totalWorkingDays;
  final int fullDayPresentCount;
  final double thisMonthPresentPercentage;

  TeacherDailyAttendanceData({
    required this.teacherId,
    required this.teacherName,
    required this.date,
    required this.morning,
    required this.afternoon,
    required this.fullDayPresent,
    required this.fullDayAbsent,
    required this.holidayStatus,
    required this.eventsStatus,
    required this.isNullStatus,
    this.eventTitle,
    this.eventImage,
    required this.monthName,
    required this.totalWorkingDays,
    required this.fullDayPresentCount,
    required this.thisMonthPresentPercentage,
  });

  factory TeacherDailyAttendanceData.fromJson(Map<String, dynamic> json) {
    return TeacherDailyAttendanceData(
      teacherId: json['teacher_id'] ?? 0,
      teacherName: json['teacher_name'] ?? '',
      date: json['date'] ?? '',
      morning: json['morning'] ?? '',
      afternoon: json['afternoon'] ?? '',
      fullDayPresent: json['full_day_present'] ?? false,
      fullDayAbsent: json['full_day_absent'] ?? false,
      holidayStatus: json['holiday_status'] ?? false,
      eventsStatus: json['events_status'] ?? false,
      isNullStatus: json['is_null_status'] ?? false,
      eventTitle: json['event_title'],
      eventImage: json['event_image'],
      monthName: json['monthName'] ?? '',
      totalWorkingDays: json['totalWorkingDays'] ?? 0,
      fullDayPresentCount: json['fullDayPresentCount'] ?? 0,
      thisMonthPresentPercentage:
      (json['this_month_present_percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'date': date,
      'morning': morning,
      'afternoon': afternoon,
      'full_day_present': fullDayPresent,
      'full_day_absent': fullDayAbsent,
      'holiday_status': holidayStatus,
      'events_status': eventsStatus,
      'is_null_status': isNullStatus,
      'event_title': eventTitle,
      'event_image': eventImage,
      'monthName': monthName,
      'totalWorkingDays': totalWorkingDays,
      'fullDayPresentCount': fullDayPresentCount,
      'this_month_present_percentage': thisMonthPresentPercentage,
    };
  }
}
