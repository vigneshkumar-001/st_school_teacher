class ExamDetailsResponse {
  final bool status;
  final int code;
  final String message;
  final ExamDetailsDatas data;

  ExamDetailsResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ExamDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ExamDetailsResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: ExamDetailsDatas.fromJson(json['data'] ?? {}),
    );
  }
}

class ExamDetailsDatas {
  final ExamTimeTable exam;
  final List<ExamSubject> subjects;
  final Permissions permissions;

  ExamDetailsDatas({
    required this.exam,
    required this.subjects,
    required this.permissions,
  });

  factory ExamDetailsDatas.fromJson(Map<String, dynamic> json) {
    return ExamDetailsDatas(
      exam: ExamTimeTable.fromJson(json['exam'] ?? {}),
      subjects: (json['subjects'] as List? ?? [])
          .map((s) => ExamSubject.fromJson(s))
          .toList(),
      permissions: Permissions.fromJson(json['permissions'] ?? {}),
    );
  }
}

class ExamTimeTable {
  final int id;
  final String heading;
  final int classId;
  final String className;
  final String section;
  final String startDate;
  final String endDate;
  final String announcementDate;
  final String? resultDate;
  final bool isPublished;
  final String timetableUrl;
  final String timetableType;

  ExamTimeTable({
    required this.id,
    required this.heading,
    required this.classId,
    required this.className,
    required this.section,
    required this.startDate,
    required this.endDate,
    required this.announcementDate,
    this.resultDate,
    required this.isPublished,
    required this.timetableUrl,
    required this.timetableType,
  });

  factory ExamTimeTable.fromJson(Map<String, dynamic> json) {
    return ExamTimeTable(
      id: json['id'] ?? 0,
      heading: json['heading'] ?? '',
      classId: json['classId'] ?? 0,
      className: json['className'] ?? '',
      section: json['section'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      announcementDate: json['announcementDate'] ?? '',
      resultDate: json['resultDate'],
      isPublished: json['isPublished'] ?? false,
      timetableUrl: json['timetableUrl'] ?? '',
      timetableType: json['timetableType'] ?? '',
    );
  }
}

class ExamSubject {
  final int examSubjectId;
  final int subjectId;
  final String subjectName;
  final int maxMarks;
  final Marks marks;

  ExamSubject({
    required this.examSubjectId,
    required this.subjectId,
    required this.subjectName,
    required this.maxMarks,
    required this.marks,
  });

  factory ExamSubject.fromJson(Map<String, dynamic> json) {
    return ExamSubject(
      examSubjectId: json['examSubjectId'] ?? 0,
      subjectId: json['subjectId'] ?? 0,
      subjectName: json['subjectName'] ?? '',
      maxMarks: json['maxMarks'] ?? 0,
      marks: Marks.fromJson(json['marks'] ?? {}),
    );
  }
}

class Marks {
  final int count;
  final String? lastUpdated;

  Marks({
    required this.count,
    this.lastUpdated,
  });

  factory Marks.fromJson(Map<String, dynamic> json) {
    return Marks(
      count: json['count'] ?? 0,
      lastUpdated: json['lastUpdated'],
    );
  }
}

class Permissions {
  final bool canEdit;
  final bool canPublish;

  Permissions({
    required this.canEdit,
    required this.canPublish,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) {
    return Permissions(
      canEdit: json['canEdit'] ?? false,
      canPublish: json['canPublish'] ?? false,
    );
  }
}
