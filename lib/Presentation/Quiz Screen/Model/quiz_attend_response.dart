/*
// attend_summary_response.dart
import 'dart:convert';

class AttendSummaryResponse {
  final bool status;
  final int code;
  final String message;
  final AttendSummaryData data;

  AttendSummaryResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  /// Accepts Map or JSON string safely.
  factory AttendSummaryResponse.fromAny(dynamic any) {
    if (any is String) {
      final map = jsonDecode(any);
      return AttendSummaryResponse.fromJson(Map<String, dynamic>.from(map));
    }
    if (any is Map) {
      return AttendSummaryResponse.fromJson(Map<String, dynamic>.from(any));
    }
    throw ArgumentError('Unsupported type for AttendSummaryResponse.fromAny');
  }

  factory AttendSummaryResponse.fromJson(Map<String, dynamic> json) {
    return AttendSummaryResponse(
      status: _toBool(json['status']),
      code: _toInt(json['code']),
      message: json['message']?.toString() ?? '',
      data: AttendSummaryData.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };

  AttendSummaryResponse copyWith({
    bool? status,
    int? code,
    String? message,
    AttendSummaryData? data,
  }) {
    return AttendSummaryResponse(
      status: status ?? this.status,
      code: code ?? this.code,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class AttendSummaryData {
  final QuizSummary quiz;
  final List<StudentDone> studentsDone;

  AttendSummaryData({
    required this.quiz,
    required this.studentsDone,
  });

  /// Quick derived metric
  int get pendingCount =>
      (quiz.totalStudents - studentsDone.length).clamp(0, 1 << 30);

  factory AttendSummaryData.fromJson(Map<String, dynamic> json) {
    return AttendSummaryData(
      quiz: QuizSummary.fromJson(
        (json['quiz'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      studentsDone: (json['studentsDone'] as List? ?? const [])
          .whereType<dynamic>()
          .where((e) => e is Map)
          .map((e) => StudentDone.fromJson(
        (e as Map).cast<String, dynamic>(),
      ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'quiz': quiz.toJson(),
    'studentsDone': studentsDone.map((e) => e.toJson()).toList(),
  };

  AttendSummaryData copyWith({
    QuizSummary? quiz,
    List<StudentDone>? studentsDone,
  }) {
    return AttendSummaryData(
      quiz: quiz ?? this.quiz,
      studentsDone: studentsDone ?? this.studentsDone,
    );
  }
}

class QuizSummary {
  final int id;
  final String title;
  final String subject;
  final String quizClass; // JSON key "class"
  final String time;      // e.g., "3:56 PM"
  final int totalQuestions;
  final int totalStudents;
  final int doneStudentsCount;

  QuizSummary({
    required this.id,
    required this.title,
    required this.subject,
    required this.quizClass,
    required this.time,
    required this.totalQuestions,
    required this.totalStudents,
    required this.doneStudentsCount,
  });

  factory QuizSummary.fromJson(Map<String, dynamic> json) {
    return QuizSummary(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      quizClass: (json['class'] ?? json['quizClass'] ?? '').toString(),
      time: json['time']?.toString() ?? '',
      totalQuestions: _toInt(json['totalQuestions']),
      totalStudents: _toInt(json['totalStudents']),
      doneStudentsCount: _toInt(json['doneStudentsCount']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'class': quizClass,
    'time': time,
    'totalQuestions': totalQuestions,
    'totalStudents': totalStudents,
    'doneStudentsCount': doneStudentsCount,
  };

  QuizSummary copyWith({
    int? id,
    String? title,
    String? subject,
    String? quizClass,
    String? time,
    int? totalQuestions,
    int? totalStudents,
    int? doneStudentsCount,
  }) {
    return QuizSummary(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      quizClass: quizClass ?? this.quizClass,
      time: time ?? this.time,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      totalStudents: totalStudents ?? this.totalStudents,
      doneStudentsCount: doneStudentsCount ?? this.doneStudentsCount,
    );
  }
}

class StudentDone {
  final int id;
  final String name;
  final int score;
  final int total;

  StudentDone({
    required this.id,
    required this.name,
    required this.score,
    required this.total,
  });

  factory StudentDone.fromJson(Map<String, dynamic> json) {
    return StudentDone(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      score: _toInt(json['score']),
      total: _toInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'score': score,
    'total': total,
  };

  StudentDone copyWith({
    int? id,
    String? name,
    int? score,
    int? total,
  }) {
    return StudentDone(
      id: id ?? this.id,
      name: name ?? this.name,
      score: score ?? this.score,
      total: total ?? this.total,
    );
  }
}

// helpers
int _toInt(dynamic v) => v is int ? v : int.tryParse('${v ?? 0}') ?? 0;
bool _toBool(dynamic v) {
  if (v is bool) return v;
  final s = v?.toString().toLowerCase();
  return s == '1' || s == 'true' || s == 'yes';
}
*/

import 'dart:convert';

class AttendSummaryResponse {
  final bool status;
  final int code;
  final String message;
  final AttendSummaryData data;

  AttendSummaryResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AttendSummaryResponse.fromAny(dynamic any) {
    if (any is String) return AttendSummaryResponse.fromJson(jsonDecode(any));
    if (any is Map) return AttendSummaryResponse.fromJson(any.cast<String, dynamic>());
    throw ArgumentError('Unsupported input to AttendSummaryResponse.fromAny');
  }

  factory AttendSummaryResponse.fromJson(Map<String, dynamic> json) {
    return AttendSummaryResponse(
      status: _b(json['status']),
      code: _i(json['code']),
      message: _s(json['message']),
      data: AttendSummaryData.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

class AttendSummaryData {
  final QuizSummary quiz;
  final List<StudentDone> studentsDone;
  final List<StudentUnfinished> studentsUnfinished; // 👈 NEW

  AttendSummaryData({
    required this.quiz,
    required this.studentsDone,
    required this.studentsUnfinished,
  });

  factory AttendSummaryData.fromJson(Map<String, dynamic> json) {
    final doneList = (json['studentsDone'] as List? ?? const []);
    final unfinishedList = (json['studentsUnfinished'] as List? ?? const []);

    return AttendSummaryData(
      quiz: QuizSummary.fromJson(
        (json['quiz'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      studentsDone: doneList
          .whereType<Map>()
          .map((e) => StudentDone.fromJson(e.cast<String, dynamic>()))
          .toList(),
      studentsUnfinished: unfinishedList
          .whereType<Map>()
          .map((e) => StudentUnfinished.fromJson(e.cast<String, dynamic>()))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'quiz': quiz.toJson(),
    'studentsDone': studentsDone.map((e) => e.toJson()).toList(),
    'studentsUnfinished': studentsUnfinished.map((e) => e.toJson()).toList(),
  };
}

class QuizSummary {
  final int id;
  final String title;
  final String subject;
  final String className; // maps from "class"
  final String time;
  final int totalQuestions;
  final int totalStudents;
  final int doneStudentsCount;

  QuizSummary({
    required this.id,
    required this.title,
    required this.subject,
    required this.className,
    required this.time,
    required this.totalQuestions,
    required this.totalStudents,
    required this.doneStudentsCount,
  });

  factory QuizSummary.fromJson(Map<String, dynamic> json) {
    return QuizSummary(
      id: _i(json['id']),
      title: _s(json['title']),
      subject: _s(json['subject']),
      className: _s(json['class']),
      time: _s(json['time']),
      totalQuestions: _i(json['totalQuestions']),
      totalStudents: _i(json['totalStudents']),
      doneStudentsCount: _i(json['doneStudentsCount']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'class': className,
    'time': time,
    'totalQuestions': totalQuestions,
    'totalStudents': totalStudents,
    'doneStudentsCount': doneStudentsCount,
  };
}

class StudentDone {
  final int id;
  final String name;
  final int score;
  final int total;

  StudentDone({
    required this.id,
    required this.name,
    required this.score,
    required this.total,
  });

  factory StudentDone.fromJson(Map<String, dynamic> json) {
    return StudentDone(
      id: _i(json['id']),
      name: _s(json['name']),
      score: _i(json['score']),
      total: _i(json['total']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'score': score,
    'total': total,
  };
}

// 👇 NEW: unfinished row is just id + name
class StudentUnfinished {
  final int id;
  final String name;

  StudentUnfinished({
    required this.id,
    required this.name,
  });

  factory StudentUnfinished.fromJson(Map<String, dynamic> json) {
    return StudentUnfinished(
      id: _i(json['id']),
      name: _s(json['name']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

/// ---- tiny safe-cast helpers ----
bool _b(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) return ['true', '1', 'yes'].contains(v.toLowerCase());
  return false;
}

int _i(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

String _s(dynamic v) => (v ?? '').toString();

