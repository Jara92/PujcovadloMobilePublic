class LoginResponse {
  final String accessToken;
  final DateTime accessTokenExpiration;
  final String userId;

  LoginResponse(
      {required this.accessToken,
      required this.accessTokenExpiration,
      required this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['AccessToken'],
      accessTokenExpiration:
          DateTime.parse(json['AccessTokenExpiration'].toString()),
      userId: json['UserId'],
    );
  }
}
