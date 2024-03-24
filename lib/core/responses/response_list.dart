import 'package:pujcovadlo_client/core/responses/link_response.dart';

export 'package:pujcovadlo_client/core/constants/link_rels.dart';

class ResponseList<T> {
  final List<T> data;
  final List<LinkResponse> links;

  ResponseList({this.data = const [], this.links = const []});

  factory ResponseList.fromJson(
      Map<String, dynamic> json, Function dataFromJson) {
    return ResponseList(
      data: json['_data'] != null
          ? List<T>.from(json['_data'].map((x) => dataFromJson(x)))
          : [],
      links: json['_links'] != null
          ? List<LinkResponse>.from(
              json['_links'].map((x) => LinkResponse.fromJson(x)))
          : [],
    );
  }

  String? get nextPageLink {
    return links
        .where((element) => element.rel == LinkRels.next)
        .firstOrNull
        ?.href;
  }
}
