import 'package:pujcovadlo_client/core/responses/link_response.dart';
import 'package:pujcovadlo_client/features/profiles/responses/profile_response.dart';

class UserResponse {
  String id;

  String username;

  String firstName;

  String lastName;

  String? phoneNumber;

  String? email;

  ProfileResponse? profile;

  List<LinkResponse> links;

  UserResponse({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.email,
    this.profile,
    this.links = const [],
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
        id: json['Id'] as String,
        username: json['Username'] as String,
        firstName: json['FirstName'] as String,
        lastName: json['LastName'] as String,
        phoneNumber: json['PhoneNumber'] as String?,
        email: json['Email'] as String?,
        profile: json['Profile'] != null
            ? ProfileResponse.fromJson(json['Profile'] as Map<String, dynamic>)
            : null,
        links: (json['_links'] as List<dynamic>)
            .map((e) => LinkResponse.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}
