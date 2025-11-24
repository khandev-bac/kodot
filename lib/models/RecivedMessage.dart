class Recivedmessage {
  String? message;
  Recivedmessage({this.message});
  factory Recivedmessage.fromJson(Map<String, dynamic> json) {
    return Recivedmessage(message: json["message"]);
  }
}
