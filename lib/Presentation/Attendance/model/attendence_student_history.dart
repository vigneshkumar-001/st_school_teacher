class AttendanceStudentHistory {
  final bool status;
  final String message;
  final AttendanceStudentData data;

  AttendanceStudentHistory({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendanceStudentHistory.fromJson(Map<String, dynamic> json) {
    return AttendanceStudentHistory(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: AttendanceStudentData.fromJson(json['data']),
    );
  }
}

class AttendanceStudentData {
  final String studentId;
  final String studentName;
  final String studentClass;
  final String section;
  final int teacherId;
  final String classId;
  final String month;
  final String year;
  final String monthName;
  final int totalWorkingDays;
  final int fullDayPresentCount;
  final double presentPercentage;
  final Map<String, AttendanceByDate> attendanceByDate;

  AttendanceStudentData({
    required this.studentId,
    required this.studentName,
    required this.studentClass,
    required this.section,
    required this.teacherId,
    required this.classId,
    required this.month,
    required this.year,
    required this.monthName,
    required this.totalWorkingDays,
    required this.fullDayPresentCount,
    required this.presentPercentage,
    required this.attendanceByDate,
  });

  factory AttendanceStudentData.fromJson(Map<String, dynamic> json) {
    final attendanceMap = <String, AttendanceByDate>{};
    final rawAttendance =
        json['attendance_by_date'] as Map<String, dynamic>? ?? {};

    rawAttendance.forEach((key, value) {
      attendanceMap[key] = AttendanceByDate.fromJson(value);
    });

    return AttendanceStudentData(
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String,
      studentClass: json['class'] as String,
      section: json['section'] as String,
      teacherId:
          json['teacher_id'] is int
              ? json['teacher_id'] as int
              : int.tryParse(json['teacher_id'].toString()) ?? 0,
      classId: json['class_id'].toString().trim(),
      month: json['month'] as String,
      year: json['year'] as String,
      monthName: json['monthName'] as String,
      totalWorkingDays: json['totalWorkingDays'] as int,
      fullDayPresentCount: json['fullDayPresentCount'] as int,
      presentPercentage: (json['present_percentage'] as num).toDouble(),
      attendanceByDate: attendanceMap,
    );
  }
}

class AttendanceByDate {
  final String morning;
  final String afternoon;
  final bool fullDayAbsent;
  final bool holidayStatus;
  final bool eventsStatus;
  final bool isNullStatus;

  AttendanceByDate({
    required this.morning,
    required this.afternoon,
    required this.fullDayAbsent,
    required this.holidayStatus,
    required this.eventsStatus,
    required this.isNullStatus,
  });

  factory AttendanceByDate.fromJson(Map<String, dynamic> json) {
    return AttendanceByDate(
      morning: json['morning'] as String,
      afternoon: json['afternoon'] as String,
      fullDayAbsent: json['full_day_absent'] as bool,
      holidayStatus: json['holiday_status'] as bool,
      eventsStatus: json['events_status'] as bool,
      isNullStatus: json['is_null_status'] as bool,
    );
  }
}
