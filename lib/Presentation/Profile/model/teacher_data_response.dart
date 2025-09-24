class TeacherDataResponse {
  final bool status;
  final String message;
  final TeacherData data;

  TeacherDataResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TeacherDataResponse.fromJson(Map<String, dynamic> json) {
    return TeacherDataResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: TeacherData.fromJson(json['data'] ?? {}),
    );
  }
}

class TeacherData {
  final Profile profile;
  final List<ClassInfo> classes;

  TeacherData({required this.profile, required this.classes});

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    return TeacherData(
      profile: Profile.fromJson(json['profile'] ?? {}),
      classes:
          (json['classes'] as List<dynamic>? ?? [])
              .map((e) => ClassInfo.fromJson(e))
              .toList(),
    );
  }
}

class Profile {
  final String staffName;
  final String mobile;
  late final String profileImg;

  Profile({required this.staffName, required this.mobile,required this.profileImg});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      staffName: json['staff_name'] ?? '',
      profileImg: json['profile_img'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}

class ClassInfo {
  final String className;
  final List<String> sections;
  final List<Subject> subjects;

  ClassInfo({
    required this.className,
    required this.sections,
    required this.subjects,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      className: json['className'] ?? '',
      sections:
          (json['sections'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
      subjects:
          (json['subjects'] as List<dynamic>? ?? [])
              .map((e) => Subject.fromJson(e))
              .toList(),
    );
  }
}

class Subject {
  final int id;
  final String name;
  final String section; // ✅ new field

  Subject({required this.id, required this.name, required this.section});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      section: json['section'] ?? '',
    );
  }
}

