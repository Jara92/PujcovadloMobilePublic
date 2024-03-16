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

  factory ProfileResponse.fromJson(Map<String, Object> json) {
    return ProfileResponse(
      id: json['id'] as int,
      description: json['description'] as String?,
      profileImage: json['profileImage'] != null
          ? ImageResponse.fromJson(json['profileImage'] as Map<String, Object>)
          : null,
      //user: UserResponse.fromJson(json['user'] as Map<String, Object>),
      links: (json['links'] as List<Object>)
          .map((e) => LinkResponse.fromJson(e as Map<String, Object>))
          .toList(),
      aggregations: json['aggregations'] != null
          ? ProfileAggregations.fromJson(
              json['aggregations'] as Map<String, Object>)
          : null,
    );
  }
}
