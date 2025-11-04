import 'dart:convert';

class ResentOtpResponse {
  final bool status;
  final int code;
  final String message;
  final Meta meta;

  ResentOtpResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.meta,
  });

  factory ResentOtpResponse.fromJson(Map<String, dynamic> json) =>
      ResentOtpResponse(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        message: json["message"] ?? '',
        meta: Meta.fromJson(json["meta"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "meta": meta.toJson(),
  };
}

class Meta {
  final int nextAllowedIn;
  final int remainingThisHour;

  Meta({required this.nextAllowedIn, required this.remainingThisHour});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    nextAllowedIn: json["nextAllowedIn"] ?? 0,
    remainingThisHour: json["remainingThisHour"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "nextAllowedIn": nextAllowedIn,
    "remainingThisHour": remainingThisHour,
  };
}
