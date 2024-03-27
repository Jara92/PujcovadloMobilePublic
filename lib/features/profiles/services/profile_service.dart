import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/core/services/image_service.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';

class ProfileService {
  final Config config = GetIt.instance.get<Config>();
  final HttpService http = GetIt.instance.get<HttpService>();
  final ImageService imageService = GetIt.instance.get<ImageService>();

  Future<UserResponse> getItemByUri(String uri) {
    return _getItemByUri(Uri.parse(uri));
  }

  Future<UserResponse> getUserById(int id) async {
    return _getItemByUri(Uri.parse("${config.apiEndpoint}/items/$id"));
  }

  Future<UserResponse> _getItemByUri(Uri uri) async {
    final response = await http.get(uri: uri);

    // Parse JSON if the server returned a 200 OK response
    if (response.isSuccessCode) {
      var data = UserResponse.fromJson(jsonDecode(response.body));

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to load item: ${response.statusCode} ${response.body}');
    }
  }
}
