class QuizDetailsPreview {
  final bool status;
  final int code;
  final String message;
  final QuizDetailsData? data; // <-- nullable

  QuizDetailsPreview({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory QuizDetailsPreview.fromJson(Map<String, dynamic> json) {
    return QuizDetailsPreview(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? QuizDetailsData.fromJson(json['data']) : null,
    );
  }
}


class QuizDetailsData {
  final int id;
  final String title;
  final int timeLimit;
  final String date;
  final String time;
  final QuizClass quizClass;
  final Subject subject;
  final List<Question> questions;

  QuizDetailsData({
    required this.id,
    required this.title,
    required this.timeLimit,
    required this.date,
    required this.time,
    required this.quizClass,
    required this.subject,
    required this.questions,
  });

  factory QuizDetailsData.fromJson(Map<String, dynamic> json) {
    return QuizDetailsData(
      id: json['id'],
      title: json['title'],
      timeLimit: json['timeLimit'],
      date: json['date'],
      time: json['time'],
      quizClass: QuizClass.fromJson(json['class']),
      subject: Subject.fromJson(json['subject']),
      questions:
      (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }
}

class QuizClass {
  final int id;
  final String name;
  final String section;

  QuizClass({required this.id, required this.name, required this.section});

  factory QuizClass.fromJson(Map<String, dynamic> json) {
    return QuizClass(
      id: json['id'],
      name: json['name'],
      section: json['section'],
    );
  }
}

class Subject {
  final int id;
  final String name;

  Subject({required this.id, required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(id: json['id'], name: json['name']);
  }
}

class Question {
  final int id;
  final String text;
  final List<Option> options;

  Question({required this.id, required this.text, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options:
      (json['options'] as List).map((o) => Option.fromJson(o)).toList(),
    );
  }
}

class Option {
  final int id;
  final String text;
  final bool isCorrect;

  Option({required this.id, required this.text, required this.isCorrect});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      text: json['text'],
      isCorrect: json['isCorrect'],
    );
  }
}