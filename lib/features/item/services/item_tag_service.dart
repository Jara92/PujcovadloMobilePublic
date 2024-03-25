import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/responses/response_list.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/features/item/filters/item_tag_filter.dart';
import 'package:pujcovadlo_client/features/item/responses/item_tag_response.dart';

class ItemTagService {
  final Config config = GetIt.instance.get<Config>();
  final HttpService _http = GetIt.instance.get<HttpService>();

  Future<ResponseList<ItemTagResponse>> getTags(ItemTagFilter filter) async {
    final uri = Uri.parse("${config.apiEndpoint}/item-tags")
        .replace(queryParameters: filter.toMap());

    final response = await _http.get(uri: uri);

    // Parse JSON if the server returned a 200 OK response
    if (response.isSuccessCode) {
      var data = ResponseList<ItemTagResponse>.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
          ItemTagResponse.fromJson);

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to load tags: ${response.statusCode} ${response.body}');
    }
  }
}
