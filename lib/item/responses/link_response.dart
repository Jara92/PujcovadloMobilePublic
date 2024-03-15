class LinkResponse {
  String? href;
  String rel;
  String method;

  LinkResponse({required this.href, required this.rel, required this.method});

  factory LinkResponse.fromJson(Map<String, Object> json) {
    return LinkResponse(
      href: json['href'] as String?,
      rel: json['rel'] as String,
      method: json['method'] as String,
    );
  }
}
