class Userinfo {
  final String? userId;
  final String? userName;
  final String? email;
  final String? profile;
  final String? fcmToken;
  final String? createdAt;

  Userinfo({
    this.userId,
    this.userName,
    this.email,
    this.profile,
    this.fcmToken,
    this.createdAt,
  });

  factory Userinfo.fromJson(Map<String, dynamic> json) {
    return Userinfo(
      userId: json['user_id'] as String?,
      userName: json['username'] as String?,
      email: json['email'] as String?,
      profile: json['profile'] != null && json['profile']['Valid'] == true
          ? json['profile']['String']
          : null,
      fcmToken: json['fcm_token'] != null && json['fcm_token']['Valid'] == true
          ? json['fcm_token']['String']
          : null,
      createdAt:
          json['created_at'] != null && json['created_at']['Valid'] == true
          ? json['created_at']['Time']
          : null,
    );
  }
}
