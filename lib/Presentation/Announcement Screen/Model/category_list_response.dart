class CategoryListResponse {
  final bool status;
  final int code;
  final String message;
  final List<CategoryData> data;

  CategoryListResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    return CategoryListResponse(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => CategoryData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryData {
  final int id;
  final String name;
  final String slug;
  final String? image;
  final bool status;
  final DateTime createdAt;
  // final DateTime updatedAt;

  CategoryData({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    required this.status,
    required this.createdAt,
    // required this.updatedAt,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image']?? '',
      status: json['status'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      // updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
