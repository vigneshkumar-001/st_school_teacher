// student_quiz_result.dart
import 'dart:convert';

class StudentQuizResult {
  final bool status;
  final int code;
  final String message;
  final StudentQuizData data;

  StudentQuizResult({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory StudentQuizResult.fromAny(dynamic any) {
    if (any is String) return StudentQuizResult.fromJson(jsonDecode(any));
    if (any is Map)   return StudentQuizResult.fromJson(any.cast<String, dynamic>());
    throw ArgumentError('Unsupported type for StudentQuizResult.fromAny');
  }

  factory StudentQuizResult.fromJson(Map<String, dynamic> json) {
    return StudentQuizResult(
      status: json['status'] == true,
      code: json['code'] is int ? json['code'] : int.tryParse('${json['code'] ?? 0}') ?? 0,
      message: json['message']?.toString() ?? '',
      data: StudentQuizData.fromJson((json['data'] as Map?)?.cast<String, dynamic>() ?? const {}),
    );
  }
}

class StudentQuizData {
  final SQStudent student;
  final SQQuiz quiz;
  final int score;
  final int total;
  final String time;
  final List<SQQuestion> questions;


  StudentQuizData({
    required this.student,
    required this.quiz,
    required this.score,
    required this.total,
    required this.time,
    required this.questions,
  });

  factory StudentQuizData.fromJson(Map<String, dynamic> json) {
    return StudentQuizData(
      student: SQStudent.fromJson((json['student'] as Map?)?.cast<String, dynamic>() ?? const {}),
      quiz: SQQuiz.fromJson((json['quiz'] as Map?)?.cast<String, dynamic>() ?? const {}),
      score: _toInt(json['score']),
      total: _toInt(json['total']),
      time: json['time']?? '',
      questions: (json['questions'] as List? ?? const [])
          .map((e) => SQQuestion.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );
  }

  static int _toInt(dynamic v) => v is int ? v : int.tryParse('$v') ?? 0;
}

class SQStudent {
  final int id;
  final String name;
  SQStudent({required this.id, required this.name});

  factory SQStudent.fromJson(Map<String, dynamic> json) {
    return SQStudent(
      id: StudentQuizData._toInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }
}

class SQQuiz {
  final int id;
  final String title;
  SQQuiz({required this.id, required this.title});

  factory SQQuiz.fromJson(Map<String, dynamic> json) {
    return SQQuiz(
      id: StudentQuizData._toInt(json['id']),
      title: json['title']?.toString() ?? '',
    );
  }
}

class SQQuestion {
  final int id;
  final String text;
  final List<SQOption> options;

  SQQuestion({required this.id, required this.text, required this.options});

  factory SQQuestion.fromJson(Map<String, dynamic> json) {
    return SQQuestion(
      id: StudentQuizData._toInt(json['id']),
      text: json['text']?.toString() ?? '',
      options: (json['options'] as List? ?? const [])
          .map((e) => SQOption.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
    );
  }
}

class SQOption {
  final int id;
  final String text;
  final bool isCorrect;
  final bool selected;

  SQOption({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.selected,
  });

  factory SQOption.fromJson(Map<String, dynamic> json) {
    return SQOption(
      id: StudentQuizData._toInt(json['id']),
      text: json['text']?.toString() ?? '',
      isCorrect: json['isCorrect'] == true,
      selected: json['selected'] == true,
    );
  }
}
