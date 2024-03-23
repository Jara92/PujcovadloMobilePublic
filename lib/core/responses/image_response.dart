import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'link_response.dart';

class ImageResponse {
  int id;

  String? name;

  String path;

  String url;

  List<LinkResponse> links = [];

  ImageResponse({required this.id,
    required this.name,
    required this.path,
    required this.url,
    this.links = const []});

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(
      id: json['Id'] as int,
      name: json['Name'] as String?,
      path: json['Path'] as String,
      url: getUrl(json['Url'] as String),
      links: (json['_links'] as List)
          .map((e) => LinkResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

String getUrl(String url) {
  if (kDebugMode) {
    return url.replaceFirst(
        "http://localhost:9000", dotenv.env['IMAGES_ENDPOINT']!);
  }

  return url;
}
