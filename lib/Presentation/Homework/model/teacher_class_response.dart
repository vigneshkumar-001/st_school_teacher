class TeacherClassResponse {
  final bool status;
  final int code;
  final String message;
  final TeacherData data;

  TeacherClassResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory TeacherClassResponse.fromJson(Map<String, dynamic> json) {
    return TeacherClassResponse(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: TeacherData.fromJson(json['data']),
    );
  }
}

class TeacherData {
  final List<TeacherClass> classes;
  final List<TeacherSubject> subjects;

  TeacherData({required this.classes, required this.subjects});

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    return TeacherData(
      classes:
          (json['classes'] as List)
              .map((e) => TeacherClass.fromJson(e))
              .toList(),
      subjects:
          (json['subjects'] as List)
              .map((e) => TeacherSubject.fromJson(e))
              .toList(),
    );
  }
}

class TeacherClass {
  final int id;
  final String name;
  final String section;

  TeacherClass({required this.id, required this.name, required this.section});

  factory TeacherClass.fromJson(Map<String, dynamic> json) {
    return TeacherClass(
      id: json['id'],
      name: json['name'],
      section: json['section'],
    );
  }
}

class TeacherSubject {
  final int id;
  final String name;
  final int classId;

  TeacherSubject({required this.id, required this.name, required this.classId});

  factory TeacherSubject.fromJson(Map<String, dynamic> json) {
    return TeacherSubject(
      id: json['id'],
      name: json['name'],
      classId: json['classId'],
    );
  }
}
