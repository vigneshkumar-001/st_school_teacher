class AnnouncementDetailsResponse {
  final bool status;
  final int code;
  final String message;
  final AnnouncementDetails? data;

  AnnouncementDetailsResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AnnouncementDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementDetailsResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data:
      json['data'] != null
          ? AnnouncementDetails.fromJson(json['data'])
          : null,
    );
  }
}

class AnnouncementDetails {
  final int id;
  final String title;
  final String category;
  final String announcementCategory;
  final int classId;
  final String notifyDate;
  final int createdBy;
  final int userType;
  final String content;
  final List<AnnouncementContent> contents;

  AnnouncementDetails({
    required this.id,
    required this.title,
    required this.category,
    required this.announcementCategory,
    required this.classId,
    required this.notifyDate,
    required this.createdBy,
    required this.userType,
    required this.content,
    required this.contents,
  });

  factory AnnouncementDetails.fromJson(Map<String, dynamic> json) {
    return AnnouncementDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      announcementCategory: json['announcementCategory'] ?? '',
      classId: json['classId'] ?? 0,
      notifyDate: json['notifyDate'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      userType: json['userType'] ?? 0,
      content: json['content'] ?? '',
      contents:
      (json['contents'] as List<dynamic>?)
          ?.map((e) => AnnouncementContent.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class AnnouncementContent {
  final String type;
  final String? content;
  final List<String>? items;
  final int position;

  AnnouncementContent({
    required this.type,
    this.content,
    this.items,
    required this.position,
  });

  factory AnnouncementContent.fromJson(Map<String, dynamic> json) {
    return AnnouncementContent(
      type: json['type'] ?? '',
      content: json['content'],
      items: (json['items'] as List?)?.map((e) => e.toString()).toList(),
      position: json['position'] ?? 0,
    );
  }
}
