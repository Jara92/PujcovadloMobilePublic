import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/responses/error_response.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/core/services/secured_storage.dart';
import 'package:pujcovadlo_client/features/authentication/exceptions/email_exists.dart';
import 'package:pujcovadlo_client/features/authentication/exceptions/invalid_credentials.dart';
import 'package:pujcovadlo_client/features/authentication/exceptions/username_exists.dart';
import 'package:pujcovadlo_client/features/authentication/requests/login_request.dart';
import 'package:pujcovadlo_client/features/authentication/requests/register_request.dart';
import 'package:pujcovadlo_client/features/authentication/responses/login_response.dart';

enum AuthenticationStateEnum { unknown, authenticated, unauthenticated }

class AuthenticationService {
  final SecuredStorage _securedStorage = GetIt.instance.get<SecuredStorage>();
  final Config config = GetIt.instance.get<Config>();
  final HttpService _http = GetIt.instance.get<HttpService>();
  final _controller = StreamController<AuthenticationStateEnum>();

  String? _accessToken;
  DateTime? _accessTokenExpiration;
  String? _userId;

  Future<AuthenticationStateEnum> get currentStatus => _controller.stream.last;

  String? get accessToken => _accessToken;

  String? get currentUserId => _userId;

  DateTime? get accessTokenExpiration => _accessTokenExpiration;

  /// Stream of authentication state changes
  Stream<AuthenticationStateEnum> get status async* {
    // Start with unknown state
    yield AuthenticationStateEnum.unknown;

    // Try to recover session and yield the state
    yield await recoverSession();

    // Yield the state from the controller
    yield* _controller.stream;
  }

  /// Tries to recover the session from the secured storage
  Future<AuthenticationStateEnum> recoverSession() async {
    _accessToken = await _securedStorage.getAccessToken();
    _accessTokenExpiration = await _securedStorage.getAccessTokenExpiration();
    _userId = await _securedStorage.getUserId();

    // If the access token is still valid, return authenticated
    if (hasValidAccessToken) {
      return AuthenticationStateEnum.authenticated;
    }
    // TODO: Refresh token
    // Otherwise, return unauthenticated
    else {
      return AuthenticationStateEnum.unauthenticated;
    }
  }

  /// Returns true if the access token is set and is not expired
  bool get hasValidAccessToken =>
      _accessToken != null &&
      _accessTokenExpiration != null &&
      _accessTokenExpiration!.isAfter(DateTime.now());

  Future<void> login(
      {required String username, required String password}) async {
    final request = LoginRequest(username: username, password: password);

    Uri uri = Uri.parse("${config.apiEndpoint}/login");

    var response = await _http.post(
      uri: uri,
      body: request.toJson(),
    );

    // Do the login if the response is successful
    if (response.isSuccessCode) {
      final auth = LoginResponse.fromJson(response.data);
      await _loginFromResponse(auth);
      return;
    }

    // Authentication failed
    _controller.add(AuthenticationStateEnum.unauthenticated);

    // Throw an exception if the credentials are invalid
    if (response.statusCode == HttpStatus.unauthorized) {
      throw const InvalidCredentialsException();
    }

    throw Exception("Something went wrong");
  }

  Future<void> _loginFromResponse(LoginResponse auth) async {
    // Set access token and store it
    _accessToken = auth.accessToken;
    await _securedStorage.saveAccessToken(_accessToken!);

    // Set access token expiration and store it
    _accessTokenExpiration = auth.accessTokenExpiration;
    await _securedStorage.saveAccessTokenExpiration(_accessTokenExpiration!);

    // Set user id and store it
    _userId = auth.userId;
    await _securedStorage.saveUserId(_userId!);

    // Update status
    _controller.add(AuthenticationStateEnum.authenticated);
  }

  Future<void> logout() async {
    // Delete all the stored data so the session cannot be recovered
    _accessToken = null;
    await _securedStorage.deleteAccessToken();

    _accessTokenExpiration = null;
    await _securedStorage.deleteAccessTokenExpiration();

    _userId = null;
    await _securedStorage.deleteUserid();

    // Update status
    _controller.add(AuthenticationStateEnum.unauthenticated);
  }

  Future<void> register(RegisterRequest request) async {
    var response = await _http.post(
      uri: Uri.parse("${config.apiEndpoint}/register"),
      body: request.toJson(),
    );

    // Do the login if the response is successful
    if (response.isSuccessCode) {
      await _loginFromResponse(LoginResponse.fromJson(response.data));
    } else if (response.statusCode == HttpStatus.conflict) {
      final errorResponse = ErrorResponse.fromJson(response.data);

      if (errorResponse.errors.containsKey("Username")) {
        throw const UsernameAlreadyExists();
      } else if (errorResponse.errors.containsKey("Email")) {
        throw const EmailAlreadyExists();
      }
    } else {
      throw Exception("Failed to register");
    }
  }
}
