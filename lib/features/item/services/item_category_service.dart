import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/responses/response_list.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/features/item/responses/item_category_response.dart';

class ItemCategoryService {
  final Config config = GetIt.instance.get<Config>();
  final HttpService _http = GetIt.instance.get<HttpService>();

  Future<ResponseList<ItemCategoryResponse>> getCategories() async {
    final uri = Uri.parse("${config.apiEndpoint}/item-categories");

    final response = await _http.get(uri: uri);

    // Parse JSON if the server returned a 200 OK response
    if (response.isSuccessCode) {
      var data = ResponseList<ItemCategoryResponse>.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
          ItemCategoryResponse.fromJson);

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to load categories: ${response.statusCode} ${response.body}');
    }
  }
}
