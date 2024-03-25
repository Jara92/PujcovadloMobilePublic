import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/responses/response_list.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/features/item/filters/item_filter.dart';

import '../requests/item_request.dart';
import '../responses/item_detail_response.dart';
import '../responses/item_response.dart';

class ItemService {
  final Config config = GetIt.instance.get<Config>();
  final HttpService http = GetIt.instance.get<HttpService>();

  Future<ResponseList<ItemResponse>> getItems({ItemFilter? filter}) {
    filter ??= ItemFilter();

    var uri = Uri.parse("${config.apiEndpoint}/items")
        .replace(queryParameters: filter.toMap());

    return _getItemsByUri(uri);
  }

  Future<ResponseList<ItemResponse>> getItemsByUri(String uri) {
    return _getItemsByUri(Uri.parse(uri));
  }

  Future<ResponseList<ItemResponse>> _getItemsByUri(Uri uri) async {
    final response = await http.get(uri: uri);

    // Parse JSON if the server returned a 200 OK response
    if (response.isSuccessCode) {
      var data = ResponseList<ItemResponse>.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
          ItemResponse.fromJson);

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to load items: ${response.statusCode} ${response.body}');
    }
  }

  ItemRequest responseToRequest(ItemDetailResponse itemDetailResponse) {
    return ItemRequest(
      id: itemDetailResponse.id,
      name: itemDetailResponse.name,
      description: itemDetailResponse.description,
      pricePerDay: itemDetailResponse.pricePerDay,
      refundableDeposit: itemDetailResponse.refundableDeposit,
      sellingPrice: itemDetailResponse.sellingPrice,
      categories: itemDetailResponse.categories.map((e) => e.id).toList(),
      tags: itemDetailResponse.tags.map((e) => e.name).toList(),
/*      images: itemDetailResponse.images.map((e) => ImageRequest(
        id: e.id,
        name: e.name,
        path: e.path,
        url: e.url,
      )).toList(),
      mainImage: itemDetailResponse.mainImage != null ? ImageRequest(
        id: itemDetailResponse.mainImage!.id,
        name: itemDetailResponse.mainImage!.name,
        path: itemDetailResponse.mainImage!.path,
        url: itemDetailResponse.mainImage!.url,
      ) : null,
      tags: itemDetailResponse.tags,
      categories: itemDetailResponse.categories.map((e) => e.id).toList(),*/
    );
  }

  Future<ItemDetailResponse> getItemByUri(String uri) {
    return _getItemByUri(Uri.parse(uri));
  }

  Future<ItemDetailResponse> getItemById(int id) async {
    return _getItemByUri(Uri.parse("${config.apiEndpoint}/items/$id"));
  }

  Future<ItemDetailResponse> _getItemByUri(Uri uri) async {
    final response = await http.get(uri: uri);

    // Parse JSON if the server returned a 200 OK response
    if (response.isSuccessCode) {
      var data = ItemDetailResponse.fromJson(jsonDecode(response.body));

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to load item: ${response.statusCode} ${response.body}');
    }
  }

  Future<ItemDetailResponse> createItem(ItemRequest request) async {
    await Future.delayed(Duration(milliseconds: 1700));

    throw UnimplementedError();
  }

  Future<ItemDetailResponse> updateItem(ItemRequest item) async {
    // Update item on the server
    throw UnimplementedError();
  }

  Future<void> deleteItem(int id) async {
    // Delete item on the server
    throw UnimplementedError();
  }
}
