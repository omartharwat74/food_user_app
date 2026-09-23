/// Generic envelope parser for APIs that return:
/// `{ "status": int, "msg": "...", "data": {...} }`.
class ApiResponse<T> {
  final int status;
  final String? msg;
  final T? data;

  const ApiResponse({required this.status, this.msg, this.data});

  /// Success check based on HTTP status / response status
  bool get success => status >= 200 && status < 300;

  /// Backwards compatibility getter for legacy `message`
  String? get message => msg;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    final status = json['status'] is int
        ? (json['status'] as int)
        : (json['success'] == true ? 200 : 400);

    final msg = json['msg']?.toString() ?? json['message']?.toString();
    final rawData = json['data'];

    return ApiResponse<T>(
      status: status,
      msg: msg,
      data: rawData == null ? null : fromJsonT(rawData),
    );
  }
}
