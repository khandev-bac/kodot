class Userinfo {
  late final String? userId;
  late final String? UserName;
  late final String? Email;
  late final String? Profile;
  late final String? CreatedAt;

  Userinfo({
    this.userId,
    this.UserName,
    this.Email,
    this.Profile,
    this.CreatedAt,
  });

  factory Userinfo.fromJson(Map<String, dynamic> json) {
    return Userinfo(
      userId: json['id'] as String?,
      UserName: json['username'] as String?,
      Email: json['email'] as String?,
      Profile: json['profile'] as String?,
      CreatedAt: json["created_at"] as String?,
    );
  }
}
