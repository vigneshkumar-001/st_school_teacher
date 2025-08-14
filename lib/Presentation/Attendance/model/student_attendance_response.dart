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
      status: json['status'] as bool,
      message: json['message'] as String,
      data: StudentAttendanceData.fromJson(json['data']),
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
    required this.thisMonthPresentPercentage,
    required this.monthlyAttendanceSummary,
  });

  factory StudentAttendanceData.fromJson(Map<String, dynamic> json) {
    var list = json['monthly_attendance_summary'] as List;
    List<MonthlyAttendanceSummary> summaryList =
        list.map((e) => MonthlyAttendanceSummary.fromJson(e)).toList();

    return StudentAttendanceData(
      studentId: json['student_id'] as String,
      studentClass: json['class'] as String,
      section: json['section'] as String,
      classId: json['class_id'] as String,
      teacherId: json['teacher_id'] as int,
      date: json['date'] as String,
      morning: json['morning'] as String,
      afternoon: json['afternoon'] as String,
      fullDayPresent: json['full_day_present'] as bool,
      holidayStatus: json['holiday_status'] as bool,
      eventsStatus: json['events_status'] as bool,
      thisMonthPresentPercentage:
          (json['this_month_present_percentage'] as num).toDouble(),
      monthlyAttendanceSummary: summaryList,
    );
  }
}

class MonthlyAttendanceSummary {
  final String date;
  final String status;

  MonthlyAttendanceSummary({required this.date, required this.status});

  factory MonthlyAttendanceSummary.fromJson(Map<String, dynamic> json) {
    return MonthlyAttendanceSummary(
      date: json['date'] as String,
      status: json['status'] as String,
    );
  }
}
