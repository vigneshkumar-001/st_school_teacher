// teacher_data_models.dart
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
      data: TeacherData.fromJson(json['data'] ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class TeacherData {
  final Profile profile;
  final List<ClassInfo> classes;
  final AppVersions appVersions;
  final String greetingText; // comes from server

  TeacherData({
    required this.profile,
    required this.classes,
    required this.appVersions,
    required this.greetingText,
  });

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    return TeacherData(
      profile: Profile.fromJson(json['profile'] ?? const {}),
      classes:
          (json['classes'] as List<dynamic>? ?? [])
              .map((e) => ClassInfo.fromJson(e as Map<String, dynamic>))
              .toList(),
      appVersions: AppVersions.fromJson(json['appVersions'] ?? const {}),
      greetingText: json['greetingText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'profile': profile.toJson(),
    'classes': classes.map((e) => e.toJson()).toList(),
    'appVersions': appVersions.toJson(),
    'greetingText': greetingText,
  };
}

class Profile {
  final String staffName;
  final String mobile;
  late final String profileImg;

  Profile({
    required this.staffName,
    required this.mobile,
    required this.profileImg,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      staffName: json['staff_name'] ?? '',
      mobile: json['mobile'] ?? '',
      profileImg: json['profile_img'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'staff_name': staffName,
    'mobile': mobile,
    'profile_img': profileImg,
  };
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
              .map((e) => Subject.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'className': className,
    'sections': sections,
    'subjects': subjects.map((e) => e.toJson()).toList(),
  };
}

class Subject {
  final int id;
  final String name;

  Subject({required this.id, required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(id: (json['id'] ?? 0) as int, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AppVersions {
  final PlatformVersion android;
  final PlatformVersion ios;

  AppVersions({required this.android, required this.ios});

  factory AppVersions.fromJson(Map<String, dynamic> json) {
    return AppVersions(
      android: PlatformVersion.fromJson(json['android'] ?? const {}),
      ios: PlatformVersion.fromJson(json['ios'] ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'android': android.toJson(),
    'ios': ios.toJson(),
  };
}

class PlatformVersion {
  final String latestVersion;
  final String minVersion;
  final bool forceUpdate;
  final String storeUrl;

  PlatformVersion({
    required this.latestVersion,
    required this.minVersion,
    required this.forceUpdate,
    required this.storeUrl,
  });

  factory PlatformVersion.fromJson(Map<String, dynamic> json) {
    return PlatformVersion(
      latestVersion: json['latestVersion'] ?? '',
      minVersion: json['minVersion'] ?? '',
      forceUpdate: json['forceUpdate'] ?? false,
      storeUrl: json['storeUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'latestVersion': latestVersion,
    'minVersion': minVersion,
    'forceUpdate': forceUpdate,
    'storeUrl': storeUrl,
  };
}
