class InboxMessageModel {
  String? messageId;
  String? message;
  String? createdAt;
  String? postId;
  String? postCaption;
  String? senderId;
  String? senderUsername;
  String? senderProfile;

  InboxMessageModel({
    this.messageId,
    this.message,
    this.createdAt,
    this.postId,
    this.postCaption,
    this.senderId,
    this.senderUsername,
    this.senderProfile,
  });

  factory InboxMessageModel.fromJson(Map<String, dynamic> json) {
    return InboxMessageModel(
      messageId: json["message_id"],
      message: json["message"],
      createdAt: json["created_at"],
      postId: json["post_id"],
      postCaption: json["post_caption"],
      senderId: json["sender_id"],
      senderUsername: json["sender_username"],
      senderProfile: json["sender_profile"],
    );
  }
}
