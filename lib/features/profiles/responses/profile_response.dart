import 'package:pujcovadlo_client/core/responses/image_response.dart';
import 'package:pujcovadlo_client/core/responses/link_response.dart';
import 'package:pujcovadlo_client/features/profiles/responses/profile_aggregations.dart';

class ProfileResponse {
  int id;

  String? description;

  ImageResponse? profileImage;

//UserResponse user;

  List<LinkResponse> links;

  ProfileAggregations? aggregations;

  ProfileResponse({
    required this.id,
    this.description,
    this.profileImage,
    //required this.user,
    this.links = const [],
    this.aggregations,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['Id'] as int,
      description: json['Description'] as String?,
      profileImage: json['ProfileImage'] != null
          ? ImageResponse.fromJson(json['ProfileImage'] as Map<String, dynamic>)
          : null,
      links: (json['_links'] as List<dynamic>)
          .map((e) => LinkResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      aggregations: json['_aggregations'] != null
          ? ProfileAggregations.fromJson(
              json['_aggregations'] as Map<String, dynamic>)
          : null,
    );
  }
}
