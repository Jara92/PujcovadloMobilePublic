import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/authentication/services/authentication_service.dart';

/// Appends authorization header to every request
class AuthorizedInterceptor extends Interceptor {
  late final AuthenticationService _authenticationService =
      GetIt.instance.get<AuthenticationService>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Set Authorization header if the access token is available
    if (_authenticationService.hasValidAccessToken) {
      options.headers['Authorization'] =
          'Bearer ${_authenticationService.accessToken}';
    }

    super.onRequest(options, handler);
  }
}
