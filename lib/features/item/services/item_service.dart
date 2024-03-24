import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/responses/response_list.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';
import 'package:pujcovadlo_client/features/item/filters/item_filter.dart';

import '../../../core/responses/image_response.dart';
import '../enums/item_status.dart';
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

  List<ItemResponse> _myItems = [
    ItemResponse(
        id: 1,
        name: "Můj Item 1",
        alias: "item-1",
        status: ItemStatus.public,
        pricePerDay: 100.0,
        refundableDeposit: 2000.0,
        sellingPrice: 100.0,
        owner: UserResponse(
            id: "1",
            username: "user1",
            firstName: "User",
            lastName: "One",
            links: []),
        mainImage: ImageResponse(
            id: 1,
            name: "Můj Item 1",
            path: "item-1.jpg",
            url:
                "https://bilder.obi.cz/7d81d317-d581-42c1-b7fe-896a3b36292a/prZZB/yDrill_aku_sroubovak_bosch.jpg",
            links: [])),
    ItemResponse(
      id: 2,
      name: "Vrtačka která má hodně dlouhý název který je alespoň na 2 řádky",
      alias: "item-2",
      status: ItemStatus.public,
      pricePerDay: 200.0,
      refundableDeposit: 3000.0,
      sellingPrice: 200.0,
      owner: UserResponse(
          id: "1",
          username: "user1",
          firstName: "User",
          lastName: "One",
          links: []),
    ),
    ItemResponse(
      id: 3,
      name: "Můj Item 3",
      alias: "item-3",
      status: ItemStatus.public,
      pricePerDay: 300.0,
      sellingPrice: 300.0,
      owner: UserResponse(
          id: "1",
          username: "user1",
          firstName: "User",
          lastName: "One",
          links: []),
    ),
    ItemResponse(
      id: 4,
      name: "Můj Item 4",
      alias: "item-4",
      status: ItemStatus.public,
      pricePerDay: 400.0,
      refundableDeposit: 400.0,
      sellingPrice: 400.0,
      owner: UserResponse(
          id: "1",
          username: "user1",
          firstName: "User",
          lastName: "One",
          links: []),
    ),
    ItemResponse(
      id: 5,
      name: "Můj Item 5",
      alias: "item-5",
      status: ItemStatus.public,
      pricePerDay: 500.0,
      refundableDeposit: 500.0,
      sellingPrice: 500.0,
      owner: UserResponse(
          id: "1",
          username: "user1",
          firstName: "User",
          lastName: "One",
          links: []),
    ),
    ItemResponse(
      id: 6,
      name: "Můj Item 6",
      alias: "item-6",
      status: ItemStatus.public,
      pricePerDay: 600.0,
      refundableDeposit: 600.0,
      sellingPrice: 600.0,
      owner: UserResponse(
          id: "1",
          username: "user1",
          firstName: "User",
          lastName: "One",
          links: []),
    ),
    ItemResponse(
      id: 7,
      name: "Můj Item 7",
      alias: "item-7",
      status: ItemStatus.public,
      pricePerDay: 700.0,
      refundableDeposit: 700.0,
      sellingPrice: 700.0,
      owner: UserResponse(
          id: "1",
          username: "user1",
          firstName: "User",
          lastName: "One",
          links: []),
    ),
    ItemResponse(
      id: 8,
      name: "Můj Item 8",
      alias: "item-8",
      status: ItemStatus.public,
      pricePerDay: 800.0,
      refundableDeposit: 800.0,
      sellingPrice: 800.0,
      owner: UserResponse(
          id: "1",
          username: "user1",
          firstName: "User",
          lastName: "One",
          links: []),
    ),
  ];

/*  Future<List<ItemResponse>> getMyItems(ItemFilter filter) async {
    // Simulate a delay of 2 seconds (adjust as needed)
    //await Future.delayed(Duration(milliseconds: 1700));
    await Future.delayed(Duration(milliseconds: 500));

    // Fetch items from the server
    return _myItems;
  }*/

  Future<ItemDetailResponse?> getItemByUri(String uri) {
    return _getItemByUri(Uri.parse(uri));
  }

  Future<ItemDetailResponse?> getItemById(int id) async {
    return _getItemByUri(Uri.parse("${config.apiEndpoint}/items/$id"));
  }

  Future<ItemDetailResponse?> _getItemByUri(Uri uri) async {
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

    int id = 20;

    // Create item on the server
    return ItemDetailResponse(
      id: id,
      name: "Item ${id}",
      alias: "item",
      description:
          "Description of item ${id}. This item is very good and handy for everyone. You can use it for many purposes. I will borrow it to you for a very good price. You will be happy with it. I promise.",
      parameters: "",
      status: ItemStatus.public,
      owner: UserResponse(
          id: "1",
          username: "user1",
          firstName: "User",
          lastName: "One",
          links: []),
      pricePerDay: 100.0,
      refundableDeposit: 100.0,
      sellingPrice: 100.0,
      createdAt: DateTime.now(),
    );
  }

  Future<ItemDetailResponse> updateItem(ItemRequest item) async {
    // Update item on the server
    return ItemDetailResponse(
      id: item.id!,
      name: "Item ${item.id!}",
      alias: "item",
      description:
          "Description of item ${item.id!}. This item is very good and handy for everyone. You can use it for many purposes. I will borrow it to you for a very good price. You will be happy with it. I promise.",
      parameters: "",
      status: ItemStatus.public,
      owner: UserResponse(
          id: "1",
          username: "user1",
          firstName: "User",
          lastName: "One",
          links: []),
      pricePerDay: 100.0,
      refundableDeposit: 100.0,
      sellingPrice: 2000.0,
      createdAt: DateTime.now().add(Duration(days: -10)),
    );
  }

  Future<void> deleteItem(int id) async {
    // Delete item on the server
  }
}
