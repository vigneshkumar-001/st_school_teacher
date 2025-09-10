class ExamsResponse {
  final bool status;
  final int code;
  final String message;
  final List<Exam> exams;

  ExamsResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.exams,
  });

  factory ExamsResponse.fromJson(Map<String, dynamic> json) {
    return ExamsResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      exams: (json['exams'] as List<dynamic>?)
          ?.map((e) => Exam.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "code": code,
      "message": message,
      "exams": exams.map((e) => e.toJson()).toList(),
    };
  }
}

class Exam {
  final int id;
  final String heading;
  final String className;
  final String section;
  final String startDate;
  final String endDate;
  final String? announcementDate;
  final String? resultDate;
  final String timetableUrl;

  Exam({
    required this.id,
    required this.heading,
    required this.className,
    required this.section,
    required this.startDate,
    required this.endDate,
    this.announcementDate,
    this.resultDate,
    required this.timetableUrl,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] ?? 0,
      heading: json['heading'] ?? '',
      className: json['className'] ?? '',
      section: json['section'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      announcementDate: json['announcementDate'],
      resultDate: json['resultDate'],
      timetableUrl: json['timetableUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "heading": heading,
      "className": className,
      "section": section,
      "startDate": startDate,
      "endDate": endDate,
      "announcementDate": announcementDate,
      "resultDate": resultDate,
      "timetableUrl": timetableUrl,
    };
  }
}
