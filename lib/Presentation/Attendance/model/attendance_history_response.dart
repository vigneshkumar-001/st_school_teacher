class AttendanceHistoryResponse {
  final bool status;
  final String message;
  final AttendanceHistoryData data;

  AttendanceHistoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceHistoryResponse(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        data: AttendanceHistoryData.fromJson(json['data'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class AttendanceHistoryData {
  final String className;
  final String section;
  final int teacherId;
  final String classId;
  final String formattedDate;
  final List<Student> fullPresentStudents;
  final int fullPresentCount;
  final List<Student> fullAbsentStudents;
  final int fullAbsentCount;
  final List<Student> morningAbsentStudents;
  final int morningAbsentCount;
  final List<Student> afternoonAbsentStudents;
  final int afternoonAbsentCount;

  AttendanceHistoryData({
    required this.className,
    required this.section,
    required this.teacherId,
    required this.classId,
    required this.formattedDate,
    required this.fullPresentStudents,
    required this.fullPresentCount,
    required this.fullAbsentStudents,
    required this.fullAbsentCount,
    required this.morningAbsentStudents,
    required this.morningAbsentCount,
    required this.afternoonAbsentStudents,
    required this.afternoonAbsentCount,
  });

  factory AttendanceHistoryData.fromJson(Map<String, dynamic> json) =>
      AttendanceHistoryData(
        className: json['class'] ?? '',
        section: json['section'] ?? '',
        teacherId: json['teacher_id'] ?? 0,
        classId: json['class_id'] ?? '',
        formattedDate: json['formattedDate'] ?? '',
        fullPresentStudents: _studentList(json['full_present_students']),
        fullPresentCount: json['full_present_count'] ?? 0,
        fullAbsentStudents: _studentList(json['full_absent_students']),
        fullAbsentCount: json['full_absent_count'] ?? 0,
        morningAbsentStudents: _studentList(json['morning_absent_students']),
        morningAbsentCount: json['morning_absent_count'] ?? 0,
        afternoonAbsentStudents: _studentList(
          json['afternoon_absent_students'],
        ),
        afternoonAbsentCount: json['afternoon_absent_count'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'class': className,
    'section': section,
    'teacher_id': teacherId,
    'class_id': classId,
    'formattedDate': formattedDate,
    'full_present_students':
        fullPresentStudents.map((e) => e.toJson()).toList(),
    'full_present_count': fullPresentCount,
    'full_absent_students': fullAbsentStudents.map((e) => e.toJson()).toList(),
    'full_absent_count': fullAbsentCount,
    'morning_absent_students':
        morningAbsentStudents.map((e) => e.toJson()).toList(),
    'morning_absent_count': morningAbsentCount,
    'afternoon_absent_students':
        afternoonAbsentStudents.map((e) => e.toJson()).toList(),
    'afternoon_absent_count': afternoonAbsentCount,
  };

  static List<Student> _studentList(dynamic json) {
    if (json is List) {
      return json.map((e) => Student.fromJson(e)).toList();
    }
    return [];
  }
}

class Student {
  final int id;
  final String name;

  Student({required this.id, required this.name});

  factory Student.fromJson(Map<String, dynamic> json) =>
      Student(id: json['id'] ?? 0, name: json['name'] ?? '');

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
