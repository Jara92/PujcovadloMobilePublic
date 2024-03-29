import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/authentication/services/authentication_service.dart';

/// Logs out the user if the server returns a 401 Unauthorized status code.
class UnAuthorizedInterceptor extends Interceptor {
  late final AuthenticationService _authenticationService =
      GetIt.instance.get<AuthenticationService>();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      _authenticationService.logout();
    }

    super.onResponse(response, handler);
  }
}
