class AttendanceResponse {
  final bool status;
  final String message;
  final AttendanceData data;

  AttendanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: AttendanceData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AttendanceData {
  final String className;
  final String? messages;
  final String section;
  final String classId;
  final bool morningAttendanceDone;
  final bool afternoonAttendanceDone;

  final List<Student> presentStudentsMorning;
  final List<Student> absentStudentsMorning;
  final List<Student> lateStudentsMorning;
  final List<Student> presentStudentsAfternoon;
  final List<Student> absentStudentsAfternoon;
  final List<Student> lateStudentsAfternoon;
  final List<Student> pendingAttendance;

  final int presentStudentsMorningCount;
  final int absentStudentsMorningCount;
  final int lateStudentsMorningCount;
  final int presentStudentsAfternoonCount;
  final int absentStudentsAfternoonCount;
  final int lateStudentsAfternoonCount;
  final int pendingAttendanceCount;
  final int totalStudents;

  AttendanceData({
    required this.className,
    this.messages,
    required this.section,
    required this.classId,
    required this.morningAttendanceDone,
    required this.afternoonAttendanceDone,
    required this.presentStudentsMorning,
    required this.absentStudentsMorning,
    required this.lateStudentsMorning,
    required this.presentStudentsAfternoon,
    required this.absentStudentsAfternoon,
    required this.lateStudentsAfternoon,
    required this.pendingAttendance,
    required this.presentStudentsMorningCount,
    required this.absentStudentsMorningCount,
    required this.lateStudentsMorningCount,
    required this.presentStudentsAfternoonCount,
    required this.absentStudentsAfternoonCount,
    required this.lateStudentsAfternoonCount,
    required this.pendingAttendanceCount,
    required this.totalStudents,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      className: json['class'] ?? '',
      messages: json['messages'] ?? '',
      section: json['section'] ?? '',
      classId: json['classId'] ?? '',
      morningAttendanceDone: json['morning_attendance_done'] ?? false,
      afternoonAttendanceDone: json['afternoon_attendance_done'] ?? false,
      presentStudentsMorning: _studentList(json['present_students_morning']),
      absentStudentsMorning: _studentList(json['absent_students_morning']),
      lateStudentsMorning: _studentList(json['late_students_morning']),
      presentStudentsAfternoon:
      _studentList(json['present_students_afternoon']),
      absentStudentsAfternoon: _studentList(json['absent_students_afternoon']),
      lateStudentsAfternoon: _studentList(json['late_students_afternoon']),
      pendingAttendance: _studentList(json['pending_attendance']),
      presentStudentsMorningCount: json['present_students_morning_count'] ?? 0,
      absentStudentsMorningCount: json['absent_students_morning_count'] ?? 0,
      lateStudentsMorningCount: json['late_students_morning_count'] ?? 0,
      presentStudentsAfternoonCount:
      json['present_students_afternoon_count'] ?? 0,
      absentStudentsAfternoonCount:
      json['absent_students_afternoon_count'] ?? 0,
      lateStudentsAfternoonCount: json['late_students_afternoon_count'] ?? 0,
      pendingAttendanceCount: json['pending_attendance_count'] ?? 0,
      totalStudents: json['total_students'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class': className,
      'messages': messages,
      'section': section,
      'classId': classId,
      'morning_attendance_done': morningAttendanceDone,
      'afternoon_attendance_done': afternoonAttendanceDone,
      'present_students_morning':
      presentStudentsMorning.map((e) => e.toJson()).toList(),
      'absent_students_morning':
      absentStudentsMorning.map((e) => e.toJson()).toList(),
      'late_students_morning':
      lateStudentsMorning.map((e) => e.toJson()).toList(),
      'present_students_afternoon':
      presentStudentsAfternoon.map((e) => e.toJson()).toList(),
      'absent_students_afternoon':
      absentStudentsAfternoon.map((e) => e.toJson()).toList(),
      'late_students_afternoon':
      lateStudentsAfternoon.map((e) => e.toJson()).toList(),
      'pending_attendance': pendingAttendance.map((e) => e.toJson()).toList(),
      'present_students_morning_count': presentStudentsMorningCount,
      'absent_students_morning_count': absentStudentsMorningCount,
      'late_students_morning_count': lateStudentsMorningCount,
      'present_students_afternoon_count': presentStudentsAfternoonCount,
      'absent_students_afternoon_count': absentStudentsAfternoonCount,
      'late_students_afternoon_count': lateStudentsAfternoonCount,
      'pending_attendance_count': pendingAttendanceCount,
      'total_students': totalStudents,
    };
  }

  static List<Student> _studentList(dynamic data) {
    if (data is List) {
      return data.map((e) => Student.fromJson(e)).toList();
    }
    return [];
  }

  /// ✅ Computed getter: single student list
  List<Student> get students {
    return [
      // ...presentStudentsMorning,
      // ...absentStudentsMorning,
      // ...lateStudentsMorning,
      // ...presentStudentsAfternoon,
      // ...absentStudentsAfternoon,
      // ...lateStudentsAfternoon,
      ...pendingAttendance,
    ];
  }
}

class Student {
  final int id;
  final String name;
  bool isPresent;

  Student({
    required this.id,
    required this.name,
    this.isPresent = false,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isPresent: json['is_present'] ?? json['isPresent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_present': isPresent,
    };
  }

  Student copyWith({
    int? id,
    String? name,
    bool? isPresent,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      isPresent: isPresent ?? this.isPresent,
    );
  }
}
