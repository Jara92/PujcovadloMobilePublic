import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

export 'package:pujcovadlo_client/core/extensions/http_response/success_code.dart';

class HttpService {
  /// Builds headers for HTTP requests.
  Map<String, String> _buildHeaders(
      {bool sendAuthorizationToken = true,
      Map<String, String> headers = const {}}) {
    return {
      if (sendAuthorizationToken)
        HttpHeaders.authorizationHeader: _authorizationToken,
      ...headers,
    };
  }

  /// Sends a HTTP GET request.
  Future<Response> get(
      {required Uri uri,
      bool sendAuthorizationToken = true,
      Map<String, String> headers = const {}}) async {
    return http.get(
      uri,
      headers: _buildHeaders(
          sendAuthorizationToken: sendAuthorizationToken, headers: headers),
    );
  }

  String get _authorizationToken {
    return 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ByaW1hcnlzaWQiOiIxM2YxMWY5Mi02YzRkLTQ0ZTItYjdhOC0zNjA5ZDgwYTQzOWMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoib3duZXIiLCJqdGkiOiI2MGM5ODQ4OS0xNTMyLTRlODEtYjliMC1hMmZjNTYzYTk2ZjciLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiVXNlciIsIlRlbmFudCIsIk93bmVyIl0sImV4cCI6MTcxMTQxNTQ4OCwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MDQ2IiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MDQ2In0.CASNMsQxUjqQmlVOueFBP3pzhXWXdy8cT2edW-TNMuQ';
  }
}
