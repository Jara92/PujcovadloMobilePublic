import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/responses/response_list.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/core/services/image_service.dart';
import 'package:pujcovadlo_client/features/loan/enums/loan_status.dart';
import 'package:pujcovadlo_client/features/loan/filters/loan_filter.dart';
import 'package:pujcovadlo_client/features/loan/requests/loan_request.dart';
import 'package:pujcovadlo_client/features/loan/requests/loan_update_request.dart';
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

  Future<LoanResponse> getLoanById(int id) async {
    final uri = Uri.parse("${config.apiEndpoint}/loans/$id");

    final response = await http.get(uri: uri);

    if (response.isSuccessCode) {
      return LoanResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception(
          'Failed to load loan: ${response.statusCode} ${response.body}');
    }
  }

  Future<LoanResponse> createLoan(LoanRequest request) async {
    //await Future.delayed(Duration(seconds: 1));
    //throw Exception('Failed to create loan: 500 Internal Server Error');

    Uri uri = Uri.parse("${config.apiEndpoint}/loans");

    var response = await http.post(
      uri: uri,
      body: request.toJson(),
    );

    if (response.isSuccessCode) {
      // Parse JSON to response
      final loanResponse = LoanResponse.fromJson(jsonDecode(response.body));

      return loanResponse;
    } else {
      throw Exception(
          'Failed to create loan: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> updateLoanStatus(int loanId, LoanStatus status) async {
    final request = LoanUpdateRequest(id: loanId, status: status);

    final response = await http.put(
      uri: Uri.parse("${config.apiEndpoint}/loans/$loanId"),
      body: request.toJson(),
    );

    if (!response.isSuccessCode) {
      throw Exception(
          'Failed to update loan status: ${response.statusCode} ${response.body}');
    }
  }
}
