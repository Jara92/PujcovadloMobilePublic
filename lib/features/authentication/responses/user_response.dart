import 'package:pujcovadlo_client/core/responses/link_response.dart';
import 'package:pujcovadlo_client/features/profiles/responses/profile_response.dart';

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

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['Id'] as String,
      username: json['Username'] as String,
      firstName: json['FirstName'] as String,
      lastName: json['LastName'] as String,
        profile: json['Profile'] != null
            ? ProfileResponse.fromJson(json['Profile'] as Map<String, dynamic>)
            : null,
        links: (json['_links'] as List<dynamic>)
            .map((e) => LinkResponse.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}
