// class LoginResponse {
//   final bool status;
//   final int code;
//   final String message;
//
//   LoginResponse({
//     required this.status,
//     required this.code,
//     required this.message,
//   });
//
//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       status: json['status'],
//       code: json['code'],
//       message: json['message'] ?? '',
//     );
//   }
// }
class LoginResponse {
  final bool status;
  final int code;
  final String message;
  final String token;

  LoginResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'code': code, 'message': message, 'token': token};
  }
}
