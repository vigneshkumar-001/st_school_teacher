// announcement_models.dart
import 'dart:convert';

/// Top-level response
class AnnouncementCreateResponse {
  final bool status;
  final int code;
  final String message;
  final Announcement data;

  const AnnouncementCreateResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  /// Accepts a JSON String or Map.
  factory AnnouncementCreateResponse.fromAny(dynamic any) {
    if (any is String) {
      final map = jsonDecode(any);
      return AnnouncementCreateResponse.fromJson(
        Map<String, dynamic>.from(map),
      );
    }
    if (any is Map) {
      return AnnouncementCreateResponse.fromJson(
        Map<String, dynamic>.from(any),
      );
    }
    throw ArgumentError('Unsupported type for AnnouncementResponse.fromAny');
  }

  factory AnnouncementCreateResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementCreateResponse(
      status: _toBool(json['status']),
      code: _toInt(json['code']),
      message: _toStr(json['message'] ?? json['msg']),
      data: Announcement.fromJson(
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

/// Announcement entity
class Announcement {
  final int id;
  final String title;
  final int classId;
  final String category;
  final String? targetGroup; // null in example
  final String announcementCategory;
  final String content;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime notifyDate;
  final int userType;
  final int createdBy;
  final List<AnnouncementContent> contents;

  const Announcement({
    required this.id,
    required this.title,
    required this.classId,
    required this.category,
    required this.targetGroup,
    required this.announcementCategory,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.notifyDate,
    required this.userType,
    required this.createdBy,
    required this.contents,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    final listRaw = json['contents'] as List? ?? const [];
    return Announcement(
      id: _toInt(json['id']),
      title: _toStr(json['title']),
      classId: _toInt(json['classId'] ?? json['class_id']),
      category: _toStr(json['category']),
      targetGroup:
          json['targetGroup'] == null ? null : _toStr(json['targetGroup']),
      announcementCategory: _toStr(json['announcementCategory']),
      content: _toStr(json['content']),
      status: _toBool(json['status']),
      createdAt: _toDate(json['createdAt']),
      updatedAt: _toDate(json['updatedAt']),
      notifyDate: _toDate(json['notifyDate']),
      userType: _toInt(json['userType']),
      createdBy: _toInt(json['createdBy']),
      contents:
          listRaw
              .map(
                (e) =>
                    AnnouncementContent.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'classId': classId,
    'category': category,
    'targetGroup': targetGroup,
    'announcementCategory': announcementCategory,
    'content': content,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'notifyDate': notifyDate.toIso8601String(),
    'userType': userType,
    'createdBy': createdBy,
    'contents': contents.map((e) => e.toJson()).toList(),
  };
}

/// Content blocks inside an announcement
class AnnouncementContent {
  final int id;
  final int announcementId;
  final String type; // 'paragraph' | 'list' | 'image' | etc.
  final String content;
  final int position;

  const AnnouncementContent({
    required this.id,
    required this.announcementId,
    required this.type,
    required this.content,
    required this.position,
  });

  factory AnnouncementContent.fromJson(Map<String, dynamic> json) {
    return AnnouncementContent(
      id: _toInt(json['id']),
      announcementId: _toInt(json['announcementId'] ?? json['announcement_id']),
      type: _toStr(json['type']),
      content: _toStr(json['content']),
      position: _toInt(json['position']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'announcementId': announcementId,
    'type': type,
    'content': content,
    'position': position,
  };

  /// Convenience helpers
  bool get isParagraph => type.toLowerCase() == 'paragraph';
  bool get isList => type.toLowerCase() == 'list';
  bool get isImage => type.toLowerCase() == 'image';

  /// If this content is a 'list', the server may send a JSON-encoded array string.
  /// This parses it to List<String>. Returns empty list if not a list or invalid.
  List<String> get listItems {
    if (!isList) return const [];
    final t = content.trim();
    if (t.isEmpty) return const [];
    try {
      final decoded = jsonDecode(t);
      if (decoded is List) {
        return decoded
            .map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      }
    } catch (_) {
      // not a JSON array string; ignore
    }
    return const [];
  }
}

/// ---------- Safe helpers ----------
int _toInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

bool _toBool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase().trim();
    return s == 'true' || s == '1' || s == 'yes';
  }
  return false;
}

String _toStr(dynamic v) => v?.toString() ?? '';

DateTime _toDate(dynamic v) {
  if (v is DateTime) return v;
  if (v is String) {
    final d = DateTime.tryParse(v);
    if (d != null) return d;
  }
  // fallback: epoch
  return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}
