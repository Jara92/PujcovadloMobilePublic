import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/responses/response_list.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/core/services/image_service.dart';
import 'package:pujcovadlo_client/features/loan/filters/loan_filter.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';

class LoanService {
  final Config config = GetIt.instance.get<Config>();
  final HttpService http = GetIt.instance.get<HttpService>();
  final ImageService imageService = GetIt.instance.get<ImageService>();

  Future<ResponseList<LoanResponse>> getLoans({LoanFilter? filter}) {
    filter ??= LoanFilter();

    var uri = Uri.parse("${config.apiEndpoint}/loans")
        .replace(queryParameters: filter.toMap());

    return _getLoansByUri(uri);
  }

  Future<ResponseList<LoanResponse>> getLoansByUri(String uri) {
    return _getLoansByUri(Uri.parse(uri));
  }

  Future<ResponseList<LoanResponse>> _getLoansByUri(Uri uri) async {
    final response = await http.get(uri: uri);

    // Parse JSON if the server returned a 200 OK response
    if (response.isSuccessCode) {
      var data = ResponseList<LoanResponse>.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
          LoanResponse.fromJson);

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to load items: ${response.statusCode} ${response.body}');
    }
  }

  Future<LoanResponse> getLoanById(int i) {
    throw UnimplementedError();
  }
}
