class TeacherAttendanceResponse {
  final bool status;
  final String message;
  final TeacherAttendanceData? data;

  TeacherAttendanceResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory TeacherAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return TeacherAttendanceResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? TeacherAttendanceData.fromJson(json['data'])
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

class TeacherAttendanceData {
  final TeacherProfile? profile;
  final int month;
  final int year;
  final String monthName;
  final int totalWorkingDays;
  final int fullDayPresentCount;
  final double presentPercentage;
  final Map<String, AttendanceStatus> attendanceByDate;

  TeacherAttendanceData({
    this.profile,
    required this.month,
    required this.year,
    required this.monthName,
    required this.totalWorkingDays,
    required this.fullDayPresentCount,
    required this.presentPercentage,
    required this.attendanceByDate,
  });

  factory TeacherAttendanceData.fromJson(Map<String, dynamic> json) {
    final Map<String, AttendanceStatus> attendanceMap = {};
    if (json['attendance_by_date'] != null) {
      json['attendance_by_date'].forEach((key, value) {
        attendanceMap[key] = AttendanceStatus.fromJson(value);
      });
    }

    return TeacherAttendanceData(
      profile: json['profile'] != null
          ? TeacherProfile.fromJson(json['profile'])
          : null,
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      monthName: json['monthName'] ?? '',
      totalWorkingDays: json['totalWorkingDays'] ?? 0,
      fullDayPresentCount: json['fullDayPresentCount'] ?? 0,
      presentPercentage:
      (json['present_percentage'] ?? 0).toDouble(),
      attendanceByDate: attendanceMap,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> attendanceJson = {};
    attendanceByDate.forEach((key, value) {
      attendanceJson[key] = value.toJson();
    });

    return {
      'profile': profile?.toJson(),
      'month': month,
      'year': year,
      'monthName': monthName,
      'totalWorkingDays': totalWorkingDays,
      'fullDayPresentCount': fullDayPresentCount,
      'present_percentage': presentPercentage,
      'attendance_by_date': attendanceJson,
    };
  }
}

class TeacherProfile {
  final int id;
  final String staffName;
  final String mobile;

  TeacherProfile({
    required this.id,
    required this.staffName,
    required this.mobile,
  });

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
      id: json['id'] ?? 0,
      staffName: json['staff_name'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_name': staffName,
      'mobile': mobile,
    };
  }
}

class AttendanceStatus {
  final String morning;
  final String afternoon;
  final bool fullDayAbsent;
  final bool holidayStatus;
  final bool eventsStatus;
  final bool isNullStatus;

  AttendanceStatus({
    required this.morning,
    required this.afternoon,
    required this.fullDayAbsent,
    required this.holidayStatus,
    required this.eventsStatus,
    required this.isNullStatus,
  });

  factory AttendanceStatus.fromJson(Map<String, dynamic> json) {
    return AttendanceStatus(
      morning: json['morning'] ?? '',
      afternoon: json['afternoon'] ?? '',
      fullDayAbsent: json['full_day_absent'] ?? false,
      holidayStatus: json['holiday_status'] ?? false,
      eventsStatus: json['events_status'] ?? false,
      isNullStatus: json['is_null_status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'morning': morning,
      'afternoon': afternoon,
      'full_day_absent': fullDayAbsent,
      'holiday_status': holidayStatus,
      'events_status': eventsStatus,
      'is_null_status': isNullStatus,
    };
  }
}
