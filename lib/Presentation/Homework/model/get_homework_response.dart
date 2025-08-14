class GetHomeworkResponse {
  final bool status;
  final int code;
  final String message;
  final Map<String, List<Homework>> data;

  GetHomeworkResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetHomeworkResponse.fromJson(Map<String, dynamic> json) {
    // The "data" field is a map with keys like "Today", "Aug 8"
    // Each key maps to a list of Homework objects.
    final Map<String, List<Homework>> parsedData = {};
    (json['data'] as Map<String, dynamic>).forEach((key, value) {
      parsedData[key] =
          (value as List).map((item) => Homework.fromJson(item)).toList();
    });

    return GetHomeworkResponse(
      status: json['status'] as bool,
      code: json['code'] as int,
      message: json['message'] as String,
      data: parsedData,
    );
  }
}

class Homework {
  final int id;
  final String subject;
  final String title;
  final String classNames;
  final String time;
  final DateTime date;
  final String type;

  Homework({
    required this.id,
    required this.subject,
    required this.title,
    required this.classNames,
    required this.time,
    required this.date,
    required this.type,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'] as int,
      subject: json['subject'] as String,
      title: json['title'] as String,
      classNames: json['class'] ?? '',
      time: json['time'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
    );
  }
}
