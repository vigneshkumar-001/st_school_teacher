// // models/quiz_models.dart
// class QuizListResponse {
//   final bool status;
//   final int code;
//   final String message;
//   final QuizData data;
//
//   QuizListResponse({
//     required this.status,
//     required this.code,
//     required this.message,
//     required this.data,
//   });
//
//   factory QuizListResponse.fromJson(Map<String, dynamic> json) {
//     return QuizListResponse(
//       status:
//           (json['status'] is bool)
//               ? json['status'] as bool
//               : (json['status'] == 1 ||
//                   json['status'] == '1' ||
//                   json['status'] == 'true'),
//       code:
//           json['code'] is int
//               ? json['code'] as int
//               : int.tryParse('${json['code'] ?? 0}') ?? 0,
//       message: json['message']?.toString() ?? '',
//       data: QuizData.fromJson(
//         (json['data'] as Map?)?.cast<String, dynamic>() ?? const {},
//       ),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'status': status,
//     'code': code,
//     'message': message,
//     'data': data.toJson(),
//   };
// }
//
// class QuizData {
//   final List<QuizItem> today;
//   final List<QuizItem> yesterday;
//
//   QuizData({required this.today, required this.yesterday});
//
//   factory QuizData.fromJson(Map<String, dynamic> json) {
//     List<dynamic> _pickList(Map<String, dynamic> src, String a, String b) {
//       final vA = src[a];
//       final vB = src[b];
//       if (vA is List) return vA;
//       if (vB is List) return vB;
//       return const [];
//     }
//
//     final tList = _pickList(json, 'Today', 'today');
//     final yList = _pickList(json, 'Yesterday', 'yesterday');
//
//     final t =
//         tList
//             .map((e) => QuizItem.fromJson((e as Map).cast<String, dynamic>()))
//             .toList();
//     final y =
//         yList
//             .map((e) => QuizItem.fromJson((e as Map).cast<String, dynamic>()))
//             .toList();
//     return QuizData(today: t, yesterday: y);
//   }
//
//   Map<String, dynamic> toJson() => {
//     'Today': today.map((e) => e.toJson()).toList(),
//     'Yesterday': yesterday.map((e) => e.toJson()).toList(),
//   };
// }
//
// class QuizItem {
//   final int id;
//   final String subject;
//   final String title;
//   final String quizClass; // "class" is reserved
//   final String time;
//   final int attempted;
//   final bool published;
//
//   QuizItem({
//     required this.id,
//     required this.subject,
//     required this.title,
//     required this.quizClass,
//     required this.time,
//     required this.attempted,
//     required this.published,
//   });
//
//   factory QuizItem.fromJson(Map<String, dynamic> json) {
//     bool _toBool(dynamic v) {
//       if (v is bool) return v;
//       final s = v?.toString().toLowerCase();
//       return s == '1' || s == 'true' || s == 'yes';
//     }
//
//     int _toInt(dynamic v) => v is int ? v : int.tryParse('${v ?? 0}') ?? 0;
//
//     return QuizItem(
//       id: _toInt(json['id']),
//       subject: json['subject']?.toString() ?? '',
//       title: json['title']?.toString() ?? '',
//       quizClass: (json['class'] ?? json['quizClass'] ?? '').toString(),
//       time: json['time']?.toString() ?? '',
//       attempted: _toInt(json['attempted']),
//       published: _toBool(json['published']),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'subject': subject,
//     'title': title,
//     'class': quizClass,
//     'time': time,
//     'attempted': attempted,
//     'published': published,
//   };
// }




class QuizListResponse {
  final bool status;
  final int code;
  final String message;
  final QuizData data;

  QuizListResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory QuizListResponse.fromJson(Map<String, dynamic> json) {
    return QuizListResponse(
      status: (json['status'] is bool)
          ? json['status'] as bool
          : (json['status'] == 1 || json['status'] == '1' || json['status'] == 'true'),
      code: json['code'] is int ? json['code'] as int : int.tryParse('${json['code'] ?? 0}') ?? 0,
      message: json['message']?.toString() ?? '',
      data: QuizData.fromJson((json['data'] as Map?)?.cast<String, dynamic>() ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

class QuizData {
  /// Original two lists (kept for backward compatibility)
  final List<QuizItem> today;
  final List<QuizItem> yesterday;

  /// NEW: all date groups exactly as server sent (e.g., "Aug 29", "Aug 28", "Today", ...)
  final Map<String, List<QuizItem>> byLabel;

  QuizData({
    required this.today,
    required this.yesterday,
    required this.byLabel,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    // Build full map first
    final labels = <String, List<QuizItem>>{};
    for (final entry in json.entries) {
      final key = entry.key.toString();
      final rawList = entry.value is List ? entry.value as List : const [];
      final items = rawList
          .whereType<dynamic>()
          .map((e) => QuizItem.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
      labels[key] = items;
    }

    List<QuizItem> _pick(String want) {
      for (final e in labels.entries) {
        if (e.key.toLowerCase() == want.toLowerCase()) return e.value;
      }
      return const <QuizItem>[];
    }

    return QuizData(
      today: _pick('Today'),
      yesterday: _pick('Yesterday'),
      byLabel: labels,
    );
  }

  /// Keep toJson simple: return the full label map so nothing is lost
  Map<String, dynamic> toJson() {
    final out = <String, dynamic>{};
    byLabel.forEach((k, v) {
      out[k] = v.map((e) => e.toJson()).toList();
    });
    return out;
  }
}

class QuizItem {
  final int id;
  final String subject;
  final String title;
  final String quizClass; // "class" is reserved in Dart
  final String time; // e.g., "10:42 AM"
  final int attempted;
  final bool published;

  QuizItem({
    required this.id,
    required this.subject,
    required this.title,
    required this.quizClass,
    required this.time,
    required this.attempted,
    required this.published,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    bool _toBool(dynamic v) {
      if (v is bool) return v;
      final s = v?.toString().toLowerCase();
      return s == '1' || s == 'true' || s == 'yes';
    }

    int _toInt(dynamic v) => v is int ? v : int.tryParse('${v ?? 0}') ?? 0;

    return QuizItem(
      id: _toInt(json['id']),
      subject: json['subject']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      quizClass: (json['class'] ?? json['quizClass'] ?? '').toString(),
      time: json['time']?.toString() ?? '',
      attempted: _toInt(json['attempted']),
      published: _toBool(json['published']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'title': title,
    'class': quizClass,
    'time': time,
    'attempted': attempted,
    'published': published,
  };
}
