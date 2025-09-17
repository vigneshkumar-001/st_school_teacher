class AttendanceBulkResponse {
  final bool status;
  final String message;
  final int count;

  AttendanceBulkResponse({
    required this.status,
    required this.message,
    required this.count,
  });
  factory AttendanceBulkResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceBulkResponse(
      status: json['status']  ,
      message: json['message']?? '',
      count: json['count'],
    );
  }
}
