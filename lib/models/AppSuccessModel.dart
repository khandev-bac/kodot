class AppSuccessMessage<T> {
  final String message;
  final int statusCode;
  final T? data;

  AppSuccessMessage({
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory AppSuccessMessage.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return AppSuccessMessage(
      message: json['message'] as String,
      statusCode: json['statusCode'] as int,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
