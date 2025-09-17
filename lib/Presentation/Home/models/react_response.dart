class ReactResponse {
  final bool status;
  final int code;
  final String message;
  final ReactData? data;

  ReactResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory ReactResponse.fromJson(Map<String, dynamic> json) {
    return ReactResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? ReactData.fromJson(json['data']) : null,
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

class ReactData {
  final int id;
  final bool reacted;
  final DateTime reactedAt;

  ReactData({
    required this.id,
    required this.reacted,
    required this.reactedAt,
  });

  factory ReactData.fromJson(Map<String, dynamic> json) {
    return ReactData(
      id: json['id'] ?? 0,
      reacted: json['reacted'] ?? false,
      reactedAt: DateTime.tryParse(json['reactedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reacted': reacted,
      'reactedAt': reactedAt.toIso8601String(),
    };
  }
}
