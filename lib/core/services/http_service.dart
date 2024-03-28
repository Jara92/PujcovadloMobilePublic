import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

export 'package:pujcovadlo_client/core/extensions/http_response/success_code.dart';

class HttpService {
  late final Dio _dio;

  HttpService() {
    _dio = Dio();
    _dio.transformer = BackgroundTransformer()..jsonDecodeCallback = parseJson;
    _dio.options.validateStatus = (status) => status! < 500;
  }

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
    print(uri.toString());
    return _dio.get(uri.toString(),
        options: Options(
            headers: _buildHeaders(
                sendAuthorizationToken: sendAuthorizationToken,
                headers: headers)));
  }

  /// Sends a HTTP POST request.
  Future<Response> post({
    required Uri uri,
    required String body,
    bool sendAuthorizationToken = true,
    Map<String, String> headers = const {},
  }) async {
    return _dio.post(uri.toString(),
        data: body,
        options: Options(
            headers: _buildHeaders(
                sendAuthorizationToken: sendAuthorizationToken,
                headers: headers)));
  }

  /// Sends a HTTP PUT request.
  Future<Response> put({
    required Uri uri,
    required String body,
    bool sendAuthorizationToken = true,
    Map<String, String> headers = const {},
  }) async {
    return _dio.put(uri.toString(),
        data: body,
        options: Options(
            headers: _buildHeaders(
                sendAuthorizationToken: sendAuthorizationToken,
                headers: headers)));
  }

  /// Sends a HTTP DELETE request.
  Future<Response> delete({
    required Uri uri,
    bool sendAuthorizationToken = true,
    Map<String, String> headers = const {},
  }) async {
    print(uri);
    return _dio.delete(uri.toString(),
        options: Options(
            headers: _buildHeaders(
                sendAuthorizationToken: sendAuthorizationToken,
                headers: headers)));
  }

  /// Sends a HTTP POST request with form data.
  Future<Response> postFile({
    required Uri uri,
    required File file,
    bool sendAuthorizationToken = true,
    Map<String, String> headers = const {},
  }) async {
    // Get MIME type of the file
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    // Create form data
    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType.parse(mimeType),
      )
    });

    // Return the post request
    return _dio.post(uri.toString(),
        data: formData,
        options: Options(
            headers: _buildHeaders(
                sendAuthorizationToken: sendAuthorizationToken,
                headers: headers)));
  }

  /// Must be top-level function
  Map<String, dynamic> parseAndDecode(String response) {
    return jsonDecode(response) as Map<String, dynamic>;
  }

  String get _authorizationToken {
    return 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ByaW1hcnlzaWQiOiIxM2YxMWY5Mi02YzRkLTQ0ZTItYjdhOC0zNjA5ZDgwYTQzOWMiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoib3duZXIiLCJqdGkiOiIwOWNiZmU5ZS00MDQ4LTRjMTMtODI4Mi1mMGRkMDk5YzRlNTQiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOlsiVXNlciIsIlRlbmFudCIsIk93bmVyIl0sImV4cCI6MTcxMTY2NzExNCwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo1MDQ2IiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MDQ2In0.OkcS9bdjBUxRB2h3FfTxHfKf-UeQM0pj6ea4kOqsIjg';
  }
}

/// Must be top-level function
Map<String, dynamic> _parseAndDecode(String response) {
  return jsonDecode(response) as Map<String, dynamic>;
}

Future<Map<String, dynamic>> parseJson(String text) {
  return compute(_parseAndDecode, text);
}
