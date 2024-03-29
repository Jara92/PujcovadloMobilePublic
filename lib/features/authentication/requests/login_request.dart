import 'dart:convert';

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  String toJson() {
    return jsonEncode({
      'Username': username,
      'Password': password,
    });
  }
}
