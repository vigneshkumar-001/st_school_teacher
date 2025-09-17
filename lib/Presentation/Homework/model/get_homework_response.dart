// lib/features/homework/models/homework_models.dart
import 'package:intl/intl.dart';

class GetHomeworkResponse {
  final bool status;
  final int code;
  final String message;
  final HomeworkData data;

  GetHomeworkResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetHomeworkResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map) {
      throw const FormatException("Expected 'data' to be an object");
    }
    return GetHomeworkResponse(
      status: json['status'] == true,
      code: (json['code'] ?? 0) as int,
      message: (json['message'] ?? '') as String,
      data: HomeworkData.fromJson(data.cast<String, dynamic>()),
    );
  }
}

class HomeworkData {
  final int page;
  final int pageSize;
  final int total;

  /// e.g. { "Today": [ ... ], "Yesterday": [ ... ] }
  final Map<String, List<HomeworkItem>> groups;

  HomeworkData({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.groups,
  });

  factory HomeworkData.fromJson(Map<String, dynamic> json) {
    final rawGroups = (json['groups'] ?? {}) as Map<String, dynamic>;

    final parsedGroups = <String, List<HomeworkItem>>{};
    rawGroups.forEach((section, value) {
      final list = (value is List) ? value : const [];
      parsedGroups[section] =
          list
              .whereType<Map<String, dynamic>>()
              .map(HomeworkItem.fromJson)
              .toList();
    });

    return HomeworkData(
      page: (json['page'] ?? 1) as int,
      pageSize: (json['pageSize'] ?? 20) as int,
      total: (json['total'] ?? 0) as int,
      groups: parsedGroups,
    );
  }
}

class HomeworkItem {
  final int id;
  final String subject;
  final String title;
  final String theClass;
  final String time;
  final DateTime date;
  final String type;

  HomeworkItem({
    required this.id,
    required this.subject,
    required this.title,
    required this.theClass,
    required this.time,
    required this.date,
    required this.type,
  });

  factory HomeworkItem.fromJson(Map<String, dynamic> json) {
    final rawDate = (json['date'] ?? '') as String;
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(rawDate).toLocal();
    } catch (_) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(0);
    }
    return HomeworkItem(
      id: (json['id'] ?? 0) as int,
      subject: (json['subject'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      theClass: (json['class'] ?? '') as String,
      time: (json['time'] ?? '') as String,
      date: parsedDate,
      type: (json['type'] ?? '') as String,
    );
  }

  String formatDate({String pattern = 'dd-MMM-yyyy, hh:mm a'}) {
    return DateFormat(pattern).format(date);
  }

  /// UI convenience to match your widget usage
  String get classNames => theClass;
}
