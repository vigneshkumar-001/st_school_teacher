class AnnouncementResponse {
  final bool status;
  final int code;
  final String message;
  final AnnouncementData data;

  AnnouncementResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: AnnouncementData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': data.toJson(),
  };
}

class AnnouncementData {
  final List<AnnouncementItem> items;
  final Meta meta;

  AnnouncementData({required this.items, required this.meta});

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    return AnnouncementData(
      items:
      (json['items'] as List<dynamic>? ?? [])
          .map((e) => AnnouncementItem.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'meta': meta.toJson(),
  };
}

class AnnouncementItem {
  final int id;
  final String title;
  final String category;
  final String announcementCategory;
  final DateTime notifyDate;
  final int classId;
  final String image;
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
    return AnnouncementItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      announcementCategory: json['announcementCategory'] ?? '',
      notifyDate: DateTime.tryParse(json['notifyDate'] ?? '') ?? DateTime.now(),
      classId: json['classId'] ?? 0,
      image: json['image'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'announcementCategory': announcementCategory,
    'notifyDate': notifyDate.toIso8601String(),
    'classId': classId,
    'image': image,
    'type': type,
  };
}

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

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'pages': pages,
  };
}
