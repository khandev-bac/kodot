class Createpostmodel {
  final String? id;
  final int? boost;
  final String? code;
  final String? imageUrl;
  final String? caption;
  final List<String>? tags;

  Createpostmodel({
    this.id,
    this.boost,
    this.code,
    this.imageUrl,
    this.caption,
    this.tags,
  });

  factory Createpostmodel.fromJson(Map<String, dynamic> json) {
    return Createpostmodel(
      id: json['id'] as String?,
      boost: json['boost'] as int?,
      code: json['code'] as String?,
      imageUrl: json['image_url'] as String?,
      caption: json['caption'] as String?,
      tags: json['tags'] != null
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }
}
