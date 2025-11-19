import 'dart:io';

class Createpostmodel {
  final String userId;
  final String? code;
  final File? imageUrl;
  final String? caption;
  final List<String>? tags;

  Createpostmodel({
    required this.userId,
    this.code,
    this.imageUrl,
    this.caption,
    this.tags,
  });

  // Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'code': code,
      if (imageUrl != null) 'image_url': imageUrl,
      if (caption != null) 'caption': caption,
      if (tags != null) 'tags': tags,
    };
  }

  // Create Dart object from JSON
  factory Createpostmodel.fromJson(Map<String, dynamic> json) {
    return Createpostmodel(
      userId: json['user_id'] as String,
      code: json['code'] as String,
      imageUrl: json['image_url'] as File?,
      caption: json['caption'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
}
