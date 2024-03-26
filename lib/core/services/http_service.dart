import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

export 'package:pujcovadlo_client/core/extensions/http_response/success_code.dart';

class HttpService {
  /// Builds headers for HTTP requests.
  Map<String, String> _buildHeaders(
      {bool sendAuthorizationToken = true,
      String contentType = 'application/json',
      Map<String, String> headers = const {}}) {
    return {
      if (sendAuthorizationToken)
        HttpHeaders.authorizationHeader: _authorizationToken,
      HttpHeaders.contentTypeHeader: contentType,
      ...headers,
    };
  }

  /// Sends a HTTP GET request.
  Future<Response> get({
    required Uri uri,
    bool sendAuthorizationToken = true,
    Map<String, String> headers = const {},
  }) async {
    print(uri);
    return http.get(
      uri,
      headers: _buildHeaders(
          sendAuthorizationToken: sendAuthorizationToken, headers: headers),
    );
  }

  /// Sends a HTTP POST request.
  Future<Response> post({
    required Uri uri,
    required String body,
    bool sendAuthorizationToken = true,
    Map<String, String> headers = const {},
  }) async {
    return http.post(
      uri,
      headers: _buildHeaders(
        sendAuthorizationToken: sendAuthorizationToken,
        headers: headers,
      ),
      body: body,
    );
  }

  /// Sends a HTTP PUT request.
  Future<Response> put({
    required Uri uri,
    required String body,
    bool sendAuthorizationToken = true,
    Map<String, String> headers = const {},
  }) async {
    return http.put(
      uri,
      headers: _buildHeaders(
        sendAuthorizationToken: sendAuthorizationToken,
        headers: headers,
      ),
      body: body,
    );
  }

  /// Sends a HTTP DELETE request.
  Future<Response> delete({
    required Uri uri,
    bool sendAuthorizationToken = true,
    Map<String, String> headers = const {},
  }) async {
    print(uri);
    return http.delete(
      uri,
      headers: _buildHeaders(
          sendAuthorizationToken: sendAuthorizationToken, headers: headers),
    );
  }

  /// Sends a HTTP POST request with form data.
  Future<Response> postFile({
    required Uri uri,
    required File file,
    bool sendAuthorizationToken = true,
    Map<String, String> headers = const {},
  }) async {
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_buildHeaders(
          sendAuthorizationToken: sendAuthorizationToken,
          contentType: 'multipart/form-data',
          headers: headers));

    // Determine MIME type of the file
    final mimeType = lookupMimeType(file.path);

    // If MIME type is not found, throw an exception
    if (mimeType == null || mimeType.isEmpty) {
      throw Exception('Failed to determine MIME type of the file');
    }

    // Split MIME type into main type and sub type
    final splitMimeType = mimeType.split('/');
    if (splitMimeType.length != 2) {
      throw Exception('Failed to determine MIME type of the file');
    }

    // Get main type and sub type
    final mainType = splitMimeType[0];
    final subType = splitMimeType[1];

    // Add file to the request
    request.files.add(await http.MultipartFile.fromPath("file", file.path,
        contentType: MediaType(mainType, subType)));

    final streamResponse = await request.send();

    // Send the request
    return await http.Response.fromStream(streamResponse);
  }

  String get _authorizationToken {
    return 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ByaW1hcnlzaWQiOiIxM2YxMWY5Mi02YzRkLTQ0ZTItYjdhOC0zNjA5ZDgwYTQzOWMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoib3duZXIiLCJqdGkiOiIwOWNiZmU5ZS00MDQ4LTRjMTMtODI4Mi1mMGRkMDk5YzRlNTQiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiVXNlciIsIlRlbmFudCIsIk93bmVyIl0sImV4cCI6MTcxMTY2NzExNCwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MDQ2IiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MDQ2In0.OkcS9bdjBUxRB2h3FfTxHfKf-UeQM0pj6ea4kOqsIjg';
  }
}
