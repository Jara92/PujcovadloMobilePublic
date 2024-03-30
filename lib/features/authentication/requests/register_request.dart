import 'dart:convert';

class RegisterRequest {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? phone;
  final String password;
  final String passwordConfirmation;
  final DateTime? dateOfBirth;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.dateOfBirth,
  });

  String toJson() {
    return jsonEncode({
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'Phone': phone,
      'Password': password,
      'PasswordConfirmation': passwordConfirmation,
      'DateOfBirth': dateOfBirth?.toIso8601String(),
    });
  }
}
