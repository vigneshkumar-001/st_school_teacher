class  MessageListResponse  {
  final bool status;
  final int code;
  final String message;
  final MessageListData data;

  MessageListResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory MessageListResponse.fromJson(Map<String, dynamic> json) {
    return MessageListResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: MessageListData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class MessageListData {
  final List<NotificationItem> items;

  MessageListData({required this.items});

  factory MessageListData.fromJson(Map<String, dynamic> json) {
    var list = <NotificationItem>[];
    if (json['items'] != null) {
      list = List<Map<String, dynamic>>.from(json['items'])
          .map((e) => NotificationItem.fromJson(e))
          .toList();
    }
    return MessageListData(items: list);
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class NotificationItem {
  final int id;
  final String text;
  final DateTime createdAt;
  final bool reacted;
  final DateTime? reactedAt;
  final Student student;
  final StudentClass studentClass;

  NotificationItem({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.reacted,
    this.reactedAt,
    required this.student,
    required this.studentClass,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      reacted: json['reacted'] ?? false,
      reactedAt:
      json['reactedAt'] != null ? DateTime.parse(json['reactedAt']) : null,
      student: Student.fromJson(json['student'] ?? {}),
      studentClass: StudentClass.fromJson(json['class'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'reacted': reacted,
      'reactedAt': reactedAt?.toIso8601String(),
      'student': student.toJson(),
      'class': studentClass.toJson(),
    };
  }
}

class Student {
  final int id;
  final String name;

  Student({required this.id, required this.name});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StudentClass {
  final int id;
  final String name;
  final String section;

  StudentClass({required this.id, required this.name, required this.section});

  factory StudentClass.fromJson(Map<String, dynamic> json) {
    return StudentClass(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      section: json['section'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'section': section,
    };
  }
}
