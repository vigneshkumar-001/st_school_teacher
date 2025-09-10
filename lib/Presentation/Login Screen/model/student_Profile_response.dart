class  StudentImageResponse  {
  final bool status;
  final int code;
  final String message;
  final StudentProfileImageData? data;

  StudentImageResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory StudentImageResponse.fromJson(Map<String, dynamic> json) {
    return StudentImageResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? StudentProfileImageData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class StudentProfileImageData {
  final int studentId;
  final String profileImg;

  StudentProfileImageData({
    required this.studentId,
    required this.profileImg,
  });

  factory StudentProfileImageData.fromJson(Map<String, dynamic> json) {
    return StudentProfileImageData(
      studentId: json['studentId'] ?? 0,
      profileImg: json['profile_img'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'profile_img': profileImg,
    };
  }
}
