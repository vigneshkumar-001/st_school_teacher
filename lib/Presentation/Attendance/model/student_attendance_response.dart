class StudentAttendanceResponse {
  final bool status;
  final String message;
  final StudentAttendanceData data;

  StudentAttendanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory StudentAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: StudentAttendanceData.fromJson(json['data'] ?? {}),
    );
  }
}

class StudentAttendanceData {
  final String studentId;
  final String studentClass;
  final String section;
  final String classId;
  final int teacherId;
  final String date;
  final String morning;
  final String afternoon;
  final bool fullDayPresent;
  final bool holidayStatus;
  final bool eventsStatus;
  final bool isNullStatus;
  final String? eventTitle;
  final String? eventImage;
  final String monthName;
  final int totalWorkingDays;
  final int fullDayPresentCount;
  final double thisMonthPresentPercentage;
  final List<MonthlyAttendanceSummary> monthlyAttendanceSummary;

  StudentAttendanceData({
    required this.studentId,
    required this.studentClass,
    required this.section,
    required this.classId,
    required this.teacherId,
    required this.date,
    required this.morning,
    required this.afternoon,
    required this.fullDayPresent,
    required this.holidayStatus,
    required this.eventsStatus,
    required this.isNullStatus,
    this.eventTitle,
    this.eventImage,
    required this.monthName,
    required this.totalWorkingDays,
    required this.fullDayPresentCount,
    required this.thisMonthPresentPercentage,
    required this.monthlyAttendanceSummary,
  });

  factory StudentAttendanceData.fromJson(Map<String, dynamic> json) {
    var summaryList = (json['monthly_attendance_summary'] as List? ?? [])
        .map((e) => MonthlyAttendanceSummary.fromJson(e))
        .toList();

    return StudentAttendanceData(
      studentId: json['student_id']?.toString().trim() ?? '',
      studentClass: json['class'] ?? '',
      section: json['section'] ?? '',
      classId: json['class_id']?.toString() ?? '',
      teacherId: json['teacher_id'] is int
          ? json['teacher_id']
          : int.tryParse(json['teacher_id']?.toString() ?? '0') ?? 0,
      date: json['date'] ?? '',
      morning: json['morning'] ?? '',
      afternoon: json['afternoon'] ?? '',
      fullDayPresent: json['full_day_present'] ?? false,
      holidayStatus: json['holiday_status'] ?? false,
      eventsStatus: json['events_status'] ?? false,
      isNullStatus: json['is_null_status'] ?? false,
      eventTitle: json['event_title'] ?? '',
      eventImage: json['event_image'] ?? '',
      monthName: json['monthName'] ?? '',
      totalWorkingDays: json['totalWorkingDays'] ?? 0,
      fullDayPresentCount: json['fullDayPresentCount'] ?? 0,
      thisMonthPresentPercentage:
      (json['this_month_present_percentage'] as num?)?.toDouble() ?? 0.0,
      monthlyAttendanceSummary: summaryList,
    );
  }
}

class MonthlyAttendanceSummary {
  final String date;
  final String status;

  MonthlyAttendanceSummary({
    required this.date,
    required this.status,
  });

  factory MonthlyAttendanceSummary.fromJson(Map<String, dynamic> json) {
    return MonthlyAttendanceSummary(
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
