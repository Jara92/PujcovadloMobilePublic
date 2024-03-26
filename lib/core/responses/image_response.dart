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
      id: json['Id'].toInt(),
      name: json['Name'].toString(),
      path: json['Path'].toString(),
      url: json['Url'].toString(),
      links: (json['_links'] as List)
          .map((e) => LinkResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String? get getDeleteLink {
    return links
        .where((element) => element.rel == LinkRels.delete)
        .firstOrNull
        ?.href;
  }
}
