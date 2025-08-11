class ClassListResponse {
  final bool status;
  final int code;
  final String message;
  final List<ClassData> data;

  ClassListResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ClassListResponse.fromJson(Map<String, dynamic> json) {
    return ClassListResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ClassData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class ClassData {
  final int id;
  final String className;
  final String section;
  final int classMentorId;

  ClassData({
    required this.id,
    required this.className,
    required this.section,
    required this.classMentorId,
  });

  factory ClassData.fromJson(Map<String, dynamic> json) {
    return ClassData(
      id: json['id'] ?? 0,
      className: json['className'] ?? '',
      section: json['section'] ?? '',
      classMentorId: json['classMentorId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'className': className,
      'section': section,
      'classMentorId': classMentorId,
    };
  }
}
