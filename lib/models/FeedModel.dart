class FeedPostModel {
  final String postId;
  final String? code;
  final String? imageUrl;
  final String? caption;
  final List<String> tags;
  int boost;
  final String userId;
  final String username;
  final String? profile;

  final Socials socials;

  FeedPostModel({
    required this.postId,
    this.code,
    this.imageUrl,
    this.caption,
    required this.tags,
    required this.boost,
    required this.userId,
    required this.username,
    this.profile,
    required this.socials,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    return FeedPostModel(
      postId: json["post_id"],
      code: json["code"],
      imageUrl: json["image_url"] ?? "",
      caption: json["caption"],
      tags: List<String>.from(json["tags"] ?? []),
      boost: json["boost_score"],
      userId: json["user_id"],
      username: json["username"],
      profile: json["profile"],
      socials: Socials.fromJson(json["socials"]),
    );
  }
}

class Socials {
  final String? instagram;
  final String? github;
  final String? linkedIn;

  Socials({this.instagram, this.github, this.linkedIn});

  factory Socials.fromJson(Map<String, dynamic> json) {
    return Socials(
      instagram: json["instagram"],
      github: json["github"],
      linkedIn: json["linkedIn"],
    );
  }
}
