// class AnnouncementResponse {
//   final bool status;
//   final int code;
//   final String message;
//   final AnnouncementData data;
//
//   AnnouncementResponse({
//     required this.status,
//     required this.code,
//     required this.message,
//     required this.data,
//   });
//
//   factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
//     return AnnouncementResponse(
//       status: json['status'] ?? false,
//       code: json['code'] ?? 0,
//       message: json['message'] ?? '',
//       data: AnnouncementData.fromJson(json['data'] ?? {}),
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
// class AnnouncementData {
//   final List<AnnouncementItem> items;
//   final Meta meta;
//
//   AnnouncementData({required this.items, required this.meta});
//
//   factory AnnouncementData.fromJson(Map<String, dynamic> json) {
//     return AnnouncementData(
//       items:
//       (json['items'] as List<dynamic>? ?? [])
//           .map((e) => AnnouncementItem.fromJson(e))
//           .toList(),
//       meta: Meta.fromJson(json['meta'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'items': items.map((e) => e.toJson()).toList(),
//     'meta': meta.toJson(),
//   };
// }
//
// class AnnouncementItem {
//   final int id;
//   final String title;
//   final String category;
//   final String announcementCategory;
//   final DateTime notifyDate;
//   final int classId;
//   final String image;
//   final String type;
//
//   AnnouncementItem({
//     required this.id,
//     required this.title,
//     required this.category,
//     required this.announcementCategory,
//     required this.notifyDate,
//     required this.classId,
//     required this.image,
//     required this.type,
//   });
//
//   factory AnnouncementItem.fromJson(Map<String, dynamic> json) {
//     return AnnouncementItem(
//       id: json['id'] ?? 0,
//       title: json['title'] ?? '',
//       category: json['category'] ?? '',
//       announcementCategory: json['announcementCategory'] ?? '',
//       notifyDate: DateTime.tryParse(json['notifyDate'] ?? '') ?? DateTime.now(),
//       classId: json['classId'] ?? 0,
//       image: json['image'] ?? '',
//       type: json['type'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'title': title,
//     'category': category,
//     'announcementCategory': announcementCategory,
//     'notifyDate': notifyDate.toIso8601String(),
//     'classId': classId,
//     'image': image,
//     'type': type,
//   };
// }
//
// class Meta {
//   final int page;
//   final int limit;
//   final int total;
//   final int pages;
//
//   Meta({
//     required this.page,
//     required this.limit,
//     required this.total,
//     required this.pages,
//   });
//
//   factory Meta.fromJson(Map<String, dynamic> json) {
//     return Meta(
//       page: json['page'] ?? 0,
//       limit: json['limit'] ?? 0,
//       total: json['total'] ?? 0,
//       pages: json['pages'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'page': page,
//     'limit': limit,
//     'total': total,
//     'pages': pages,
//   };
// }


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
  final Sections sections;
  final Map<String, List<int>> groups;
  final Meta meta;

  AnnouncementData({
    required this.items,
    required this.sections,
    required this.groups,
    required this.meta,
  });

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    // Parse groups map
    Map<String, List<int>> parsedGroups = {};
    if (json['groups'] != null) {
      json['groups'].forEach((key, value) {
        parsedGroups[key] = List<int>.from(value ?? []);
      });
    }

    return AnnouncementData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => AnnouncementItem.fromJson(e))
          .toList(),
      sections: Sections.fromJson(json['sections'] ?? {}),
      groups: parsedGroups,
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'sections': sections.toJson(),
    'groups': groups.map((k, v) => MapEntry(k, v)),
    'meta': meta.toJson(),
  };
}

class AnnouncementItem {
  final int id;
  final String title;
  final String category;
  final String announcementCategory;
  final DateTime notifyDate;
  final DateTime createdAt;
  final int? classId;
  final String image;
  final String type;
  final String section;
  final List<int> sectionIds;
  final int sectionIndex;
  final String groupKey;
  final List<int> groupIds;
  final int groupIndex;

  AnnouncementItem({
    required this.id,
    required this.title,
    required this.category,
    required this.announcementCategory,
    required this.notifyDate,
    required this.createdAt,
    this.classId,
    required this.image,
    required this.type,
    required this.section,
    required this.sectionIds,
    required this.sectionIndex,
    required this.groupKey,
    required this.groupIds,
    required this.groupIndex,
  });

  factory AnnouncementItem.fromJson(Map<String, dynamic> json) {
    return AnnouncementItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      announcementCategory: json['announcementCategory'] ?? '',
      notifyDate: DateTime.tryParse(json['notifyDate'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      classId: json['classId'],
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      section: json['section'] ?? '',
      sectionIds: List<int>.from(json['sectionIds'] ?? []),
      sectionIndex: json['sectionIndex'] ?? 0,
      groupKey: json['groupKey'] ?? '',
      groupIds: List<int>.from(json['groupIds'] ?? []),
      groupIndex: json['groupIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'announcementCategory': announcementCategory,
    'notifyDate': notifyDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'classId': classId,
    'image': image,
    'type': type,
    'section': section,
    'sectionIds': sectionIds,
    'sectionIndex': sectionIndex,
    'groupKey': groupKey,
    'groupIds': groupIds,
    'groupIndex': groupIndex,
  };
}

class Sections {
  final List<int> announcementIds;
  final List<int> examIds;
  final List<int> examMarkIds;
  final List<int> eventIds;

  Sections({
    required this.announcementIds,
    required this.examIds,
    required this.examMarkIds,
    required this.eventIds,
  });

  factory Sections.fromJson(Map<String, dynamic> json) {
    return Sections(
      announcementIds: List<int>.from(json['announcementIds'] ?? []),
      examIds: List<int>.from(json['examIds'] ?? []),
      examMarkIds: List<int>.from(json['examMarkIds'] ?? []),
      eventIds: List<int>.from(json['eventIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'announcementIds': announcementIds,
    'examIds': examIds,
    'examMarkIds': examMarkIds,
    'eventIds': eventIds,
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
