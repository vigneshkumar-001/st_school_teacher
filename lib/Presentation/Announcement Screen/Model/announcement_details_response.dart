// models/announcement_detail.dart
import 'dart:convert';

/// Top-level response wrapper
class AnnouncementDetailResponse {
  final bool status;
  final int? code;
  final String? message;
  final AnnouncementDetail? data;

  AnnouncementDetailResponse({
    required this.status,
    this.code,
    this.message,
    this.data,
  });

  factory AnnouncementDetailResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementDetailResponse(
      status: (json['status'] as bool?) ?? false,
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : AnnouncementDetail.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data?.toJson(),
  };

  /// Helper if you receive a raw string
  static AnnouncementDetailResponse fromJsonString(String raw) =>
      AnnouncementDetailResponse.fromJson(json.decode(raw));
}

/// Core detail object
class AnnouncementDetail {
  final int id;
  final String title;
  final String category;
  final String announcementCategory;
  final int classId;
  final DateTime? notifyDate;
  final List<int> targetGroup; // kept as ints; parser is tolerant
  final int createdBy;
  final int userType;
  final String? content; // optional summary/description
  final List<AnnContent> contents;

  AnnouncementDetail({
    required this.id,
    required this.title,
    required this.category,
    required this.announcementCategory,
    required this.classId,
    required this.notifyDate,
    required this.targetGroup,
    required this.createdBy,
    required this.userType,
    required this.content,
    required this.contents,
  });

  factory AnnouncementDetail.fromJson(Map<String, dynamic> json) {
    return AnnouncementDetail(
      id: _asInt(json['id']),
      title: (json['title'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      announcementCategory: (json['announcementCategory'] ?? '').toString(),
      classId: _asInt(json['classId']),
      notifyDate: _parseDate(json['notifyDate']),
      targetGroup: _parseIntList(json['targetGroup']),
      createdBy: _asInt(json['createdBy']),
      userType: _asInt(json['userType']),
      content: (json['content'] as String?)?.trim(),
      contents: ((json['contents'] as List?) ?? [])
          .map((e) => AnnContent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'announcementCategory': announcementCategory,
    'classId': classId,
    'notifyDate': notifyDate?.toIso8601String(),
    'targetGroup': targetGroup,
    'createdBy': createdBy,
    'userType': userType,
    'content': content,
    'contents': contents.map((e) => e.toJson()).toList(),
  };

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.tryParse(v.toString());
    } catch (_) {
      return null;
    }
  }

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  static List<int> _parseIntList(dynamic raw) {
    if (raw is List) {
      return raw
          .map((e) {
        if (e is int) return e;
        if (e is num) return e.toInt();
        return int.tryParse(e?.toString() ?? '');
      })
          .whereType<int>()
          .toList();
    }
    return const [];
  }
}

/// Content union (paragraph | list | image)
class AnnContent {
  final ContentType type;
  final int position;

  /// For `paragraph` and `image`, API uses `content` (string).
  final String? content;

  /// For `list`, API uses `items` (array of strings).
  final List<String>? items;

  AnnContent({
    required this.type,
    required this.position,
    this.content,
    this.items,
  });

  bool get isParagraph => type == ContentType.paragraph;
  bool get isList => type == ContentType.list;
  bool get isImage => type == ContentType.image;

  factory AnnContent.fromJson(Map<String, dynamic> json) {
    final t = _typeFromString(json['type']);
    return AnnContent(
      type: t,
      position: AnnouncementDetail._asInt(json['position']),
      content: json['content'] as String?,
      items: (json['items'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          (t == ContentType.list ? <String>[] : null),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'position': position,
    if (content != null) 'content': content,
    if (items != null) 'items': items,
  };

  static ContentType _typeFromString(dynamic v) {
    final s = (v ?? '').toString().toLowerCase();
    switch (s) {
      case 'paragraph':
        return ContentType.paragraph;
      case 'list':
        return ContentType.list;
      case 'image':
        return ContentType.image;
      default:
        return ContentType.unknown;
    }
  }
}

enum ContentType { paragraph, list, image, unknown }
