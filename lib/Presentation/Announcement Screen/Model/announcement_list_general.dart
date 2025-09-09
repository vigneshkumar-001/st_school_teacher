import 'dart:convert';

/// Top-level response
class AnnouncementListResponse {
  final bool status;
  final int code;
  final String message;
  final AnnouncementData data;

  AnnouncementListResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AnnouncementListResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementListResponse(
      status: json['status'] as bool? ?? false,
      code: json['code'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: AnnouncementData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };

  /// Convenience: parse directly from a raw JSON string
  static AnnouncementListResponse parse(String source) =>
      AnnouncementListResponse.fromJson(
        json.decode(source) as Map<String, dynamic>,
      );
}

/// Data payload: list + meta
class AnnouncementData {
  final List<AnnouncementItem> items;
  final Meta meta;

  AnnouncementData({required this.items, required this.meta});

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    final list =
        (json['items'] as List<dynamic>? ?? [])
            .map((e) => AnnouncementItem.fromJson(e as Map<String, dynamic>))
            .toList();

    return AnnouncementData(
      items: list,
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

/// Single announcement row (an “item”)
class AnnouncementItem {
  final int id;
  final String title;

  /// Audience group (e.g. "Student", "Parents", "Teachers", "Staff", "All")
  final String category;

  /// Domain category/tag (e.g. "holiday", "teacher_meeting", "exam_result", "term_fee")
  final String announcementCategory;

  /// Notify date/time
  final DateTime? notifyDate;

  final int? classId;

  /// May be a full URL or a relative filename
  final String? image;

  final String type;

  AnnouncementItem({
    required this.id,
    required this.title,
    required this.category,
    required this.announcementCategory,
    required this.notifyDate,
    required this.classId,
    required this.image,
    required this.type,
  });

  factory AnnouncementItem.fromJson(Map<String, dynamic> json) {
    final String? notify = json['notifyDate'] as String?;
    return AnnouncementItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      announcementCategory: json['announcementCategory'] as String? ?? '',
      notifyDate:
          notify != null && notify.isNotEmpty
              ? DateTime.tryParse(notify)
              : null,
      classId: (json['classId'] as num?)?.toInt(),
      image: json['image'] as String?,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'announcementCategory': announcementCategory,
    'notifyDate': notifyDate?.toIso8601String(),
    'classId': classId,
    'image': image,
    'type': type,
  };

  AnnouncementItem copyWith({
    int? id,
    String? title,
    String? category,
    String? announcementCategory,
    DateTime? notifyDate,
    int? classId,
    String? image,
    String? type,
  }) {
    return AnnouncementItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      announcementCategory: announcementCategory ?? this.announcementCategory,
      notifyDate: notifyDate ?? this.notifyDate,
      classId: classId ?? this.classId,
      image: image ?? this.image,
      type: type ?? this.type,
    );
  }

  /// If the API sometimes returns only a filename, use this to resolve:
  /// `absoluteImage('https://cdn.example.com/banners/')`
  String? absoluteImage([String? base]) {
    if (image == null || image!.isEmpty) return image;
    final uri = Uri.tryParse(image!);
    if (uri != null && uri.hasScheme) return image; // already absolute
    if (base == null || base.isEmpty) return image;
    return Uri.parse(base).resolve(image!).toString();
  }
}

/// Pagination metadata
class Meta {
  final int page;
  final int limit;
  final int total;
  final int pages;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: (json['page'] as num?)?.toInt() ?? 1,
    limit: (json['limit'] as num?)?.toInt() ?? 0,
    total: (json['total'] as num?)?.toInt() ?? 0,
    pages: (json['pages'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'pages': pages,
  };
}
