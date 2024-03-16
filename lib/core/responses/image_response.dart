import 'link_response.dart';

class ImageResponse {
  int id;

  String? name;

  String path;

  String url;

  List<LinkResponse> links = [];

  ImageResponse(
      {required this.id, required this.name, required this.path, required this.url, this.links = const []});

  factory ImageResponse.fromJson(Map<String, Object> json) {
    return ImageResponse(
      id: json['id'] as int,
      name: json['name'] as String?,
      path: json['path'] as String,
      url: json['url'] as String,
      links: (json['links'] as List)
          .map((e) => LinkResponse.fromJson(e as Map<String, Object>))
          .toList(),
    );
  }
}