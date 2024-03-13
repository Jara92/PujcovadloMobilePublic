import '../enums/item_status.dart';
import '../requests/item_request.dart';
import '../responses/item_response.dart';
import '../responses/item_detail_response.dart';

class ItemService {
  Future<List<ItemResponse>> getItems() async {
    // Simulate a delay of 2 seconds (adjust as needed)
    await Future.delayed(Duration(milliseconds: 1700));

    // Fetch items from the server
    return [
      ItemResponse(
          id: 1,
          name: "Item 1",
          alias: "item-1",
          status: ItemStatus.public,
          pricePerDay: 100.0,
          refundableDeposit: 100.0,
          sellingPrice: 100.0),
    ];
  }

  Future<ItemDetailResponse> getItem(int id) async {
    // Fetch item from the server
    return ItemDetailResponse(
        id: 1,
        name: "Item 1",
        alias: "item-1",
        status: ItemStatus.public,
        pricePerDay: 100.0,
        refundableDeposit: 100.0,
        sellingPrice: 100.0);
  }

  Future<ItemDetailResponse> createItem(ItemRequest request) async {
    // Create item on the server
    return ItemDetailResponse(
        id: 1,
        name: "Item 1",
        alias: "item-1",
        status: ItemStatus.public,
        pricePerDay: 100.0,
        refundableDeposit: 100.0,
        sellingPrice: 100.0);
  }

  Future<ItemDetailResponse> updateItem(ItemRequest item) async {
    // Update item on the server
    return ItemDetailResponse(
        id: 1,
        name: "Item 1",
        alias: "item-1",
        status: ItemStatus.public,
        pricePerDay: 100.0,
        refundableDeposit: 100.0,
        sellingPrice: 100.0);
  }

  Future<void> deleteItem(int id) async {
    // Delete item on the server
  }
}
