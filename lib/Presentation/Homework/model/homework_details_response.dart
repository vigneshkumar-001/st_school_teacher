class HomeworkDetails {
  final int id;
  final String title;
  final String description;
  final String date;
  final String time;
  final ClassInfo classInfo;
  final Subject subject;
  final List<dynamic>
  tasks;

  HomeworkDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.classInfo,
    required this.subject,
    required this.tasks,
  });

  factory HomeworkDetails.fromJson(Map<String, dynamic> json) {
    return HomeworkDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      classInfo: ClassInfo.fromJson(json['class'] ?? {}),
      subject: Subject.fromJson(json['subject'] ?? {}),
      tasks: json['tasks'] ?? [],
    );
  }
}

class ClassInfo {
  final int id;
  final String name;
  final String section;

  ClassInfo({required this.id, required this.name, required this.section});

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      section: json['section'] ?? '',
    );
  }
}

class Subject {
  final int id;
  final String name;

  Subject({required this.id, required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
