export 'package:pujcovadlo_client/core/constants/link_rels.dart';

class LinkResponse {
  String? href;
  String rel;
  String method;

  LinkResponse({required this.href, required this.rel, required this.method});

  factory LinkResponse.fromJson(Map<String, dynamic> json) {
    return LinkResponse(
      href: json['Href'] as String,
      rel: json['Rel'] as String,
      method: json['Method'] as String,
    );
  }
}
