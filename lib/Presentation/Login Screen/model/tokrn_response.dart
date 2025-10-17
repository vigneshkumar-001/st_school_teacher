class TokenResponse {
  final bool status;
  final int code;
  final String message;
  final String token;

  TokenResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.token,
  });

  // From JSON
  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] as String,
      token: json['token'] as String,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'token': token,
    };
  }
}
