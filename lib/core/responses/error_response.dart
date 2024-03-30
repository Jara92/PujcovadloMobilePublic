class ErrorResponse {
  final String? title;

  final int? status;

  final Map<String, List<String>> errors;

  ErrorResponse({this.title, this.status, this.errors = const {}});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      title: json['Title']?.toString(),
      status: json['Status']?.toInt(),
      errors: _getErrors(json["Errors"]),
    );
  }

  static Map<String, List<String>> _getErrors(dynamic json) {
    if (json == null) return {};

    if (json is Map<String, dynamic>) {
      return json.map((key, value) {
        return MapEntry(key, [value.toString()]);
      });
    }

    return {};
  }
}
