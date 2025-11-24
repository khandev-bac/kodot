class Userinfo {
  final String? userId;
  final String? UserName;
  final String? Email;
  final String? Profile;
  final String? CreatedAt;

  Userinfo({
    this.userId,
    this.UserName,
    this.Email,
    this.Profile,
    this.CreatedAt,
  });

  factory Userinfo.fromJson(Map<String, dynamic> json) {
    return Userinfo(
      userId: json['user_id'] as String?,
      UserName: json['username'] as String?,
      Email: json['email'] as String?,

      // profile: {String: "...", Valid: true}
      Profile: json['profile'] != null && json['profile']['Valid'] == true
          ? json['profile']['String']
          : null,

      // created_at: {Time: "...", Valid: true}
      CreatedAt:
          json['created_at'] != null && json['created_at']['Valid'] == true
          ? json['created_at']['Time']
          : null,
    );
  }
}
