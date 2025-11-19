class CreatePostT {
  final String userId;
  final String code;
  final String? imageUrl;
  final String? caption;
  final List<String>? tags;

  CreatePostT({
    required this.userId,
    required this.code,
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
  factory CreatePostT.fromJson(Map<String, dynamic> json) {
    return CreatePostT(
      userId: json['user_id'] as String,
      code: json['code'] as String,
      imageUrl: json['image_url'] as String?,
      caption: json['caption'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }
}
