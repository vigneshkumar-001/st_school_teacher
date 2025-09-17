class StudentMarksResponse {
  final bool status;
  final int code;
  final String message;
  final List<ExamStudent> students;

  StudentMarksResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.students,
  });

  factory StudentMarksResponse.fromJson(Map<String, dynamic> json) {
    return StudentMarksResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      students:
          (json['students'] as List<dynamic>?)
              ?.map((e) => ExamStudent.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "code": code,
      "message": message,
      "students": students.map((e) => e.toJson()).toList(),
    };
  }
}

class ExamStudent {
  final int id;
  final String name;
  final String admissionNo;
  final String phone;
  final bool isComplete;
  final List<Mark> marks;

  ExamStudent({
    required this.id,
    required this.name,
    required this.admissionNo,
    required this.phone,
    required this.isComplete,
    required this.marks,
  });

  factory ExamStudent.fromJson(Map<String, dynamic> json) {
    return ExamStudent(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      admissionNo: json['admissionNo'] ?? '',
      phone: json['phone'] ?? '',
      isComplete: json['isComplete'] ?? false,
      marks:
          (json['marks'] as List<dynamic>?)
              ?.map((e) => Mark.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "admissionNo": admissionNo,
      "phone": phone,
      "isComplete": isComplete,
      "marks": marks.map((e) => e.toJson()).toList(),
    };
  }
}

class Mark {
  final int subjectId;
  final String subjectName;
    int? obtainedMarks;

  Mark({
    required this.subjectId,
    required this.subjectName,
    this.obtainedMarks,
  });

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      subjectId: json['subjectId'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      obtainedMarks: json['obtainedMarks']?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "subjectId": subjectId,
      "subjectName": subjectName,
      "obtainedMarks": obtainedMarks,
    };
  }
}
