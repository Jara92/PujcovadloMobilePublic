import 'package:pujcovadlo_client/item/responses/link_response.dart';
import 'package:pujcovadlo_client/profiles/responses/profile_response.dart';

class UserResponse {
  String id;

  String username;

  String firstName;

  String lastName;

  ProfileResponse? profile;

  List<LinkResponse> links;

  UserResponse({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.profile,
    this.links = const [],
  });

  factory UserResponse.fromJson(Map<String, Object> json) {
    return UserResponse(
      id: json['id'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profile: json['profile'] != null
          ? ProfileResponse.fromJson(json['profile'] as Map<String, Object>)
          : null,
      links: (json['links'] as List<Object>)
          .map((e) => LinkResponse.fromJson(e as Map<String, Object>))
          .toList(),
    );
  }
}
