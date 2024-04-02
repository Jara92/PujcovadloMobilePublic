import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/features/review/requests/review_request.dart';
import 'package:pujcovadlo_client/features/review/responses/review_response.dart';

class ReviewService {
  final Config config = GetIt.instance.get<Config>();
  final HttpService http = GetIt.instance.get<HttpService>();

  Future<ReviewResponse> createReview(ReviewRequest request) async {
    final uri =
        Uri.parse("${config.apiEndpoint}/loans/${request.loanId}/reviews");

    var response = await http.post(
      uri: uri,
      body: request.toJson(),
    );

    if (response.isSuccessCode) {
      // Parse JSON to response
      final reviewResponse = ReviewResponse.fromJson(response.data);

      // return item response with images
      return reviewResponse;
    } else {
      throw Exception(
          'Failed to create review: ${response.statusCode} ${response.data}');
    }
  }
}
