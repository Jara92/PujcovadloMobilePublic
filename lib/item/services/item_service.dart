import '../enums/item_status.dart';
import '../requests/item_request.dart';
import '../responses/image_response.dart';
import '../responses/item_response.dart';
import '../responses/item_detail_response.dart';

class ItemService {
  Future<List<ItemResponse>> getItems() async {
    // Simulate a delay of 2 seconds (adjust as needed)
    //await Future.delayed(Duration(milliseconds: 1700));
    await Future.delayed(Duration(milliseconds: 500));

    // Fetch items from the server
    return [
      ItemResponse(
          id: 1,
          name: "Item 1",
          alias: "item-1",
          status: ItemStatus.public,
          pricePerDay: 100.0,
          refundableDeposit: 2000.0,
          sellingPrice: 100.0,
          mainImage: ImageResponse(
              id: 1,
              name: "Item 1",
              path: "item-1.jpg",
              url:
                  "https://bilder.obi.cz/7d81d317-d581-42c1-b7fe-896a3b36292a/prZZB/yDrill_aku_sroubovak_bosch.jpg",
              links: [])),
      ItemResponse(
          id: 2,
          name:
              "Vrtačka která má hodně dlouhý název který je alespoň na 2 řádky",
          alias: "item-2",
          status: ItemStatus.public,
          pricePerDay: 200.0,
          refundableDeposit: 3000.0,
          sellingPrice: 200.0),
      ItemResponse(
          id: 3,
          name: "Item 3",
          alias: "item-3",
          status: ItemStatus.public,
          pricePerDay: 300.0,
          sellingPrice: 300.0),
      ItemResponse(
          id: 4,
          name: "Item 4",
          alias: "item-4",
          status: ItemStatus.public,
          pricePerDay: 400.0,
          refundableDeposit: 400.0,
          sellingPrice: 400.0),
      ItemResponse(
          id: 5,
          name: "Item 5",
          alias: "item-5",
          status: ItemStatus.public,
          pricePerDay: 500.0,
          refundableDeposit: 500.0,
          sellingPrice: 500.0),
      ItemResponse(
          id: 6,
          name: "Item 6",
          alias: "item-6",
          status: ItemStatus.public,
          pricePerDay: 600.0,
          refundableDeposit: 600.0,
          sellingPrice: 600.0),
      ItemResponse(
          id: 7,
          name: "Item 7",
          alias: "item-7",
          status: ItemStatus.public,
          pricePerDay: 700.0,
          refundableDeposit: 700.0,
          sellingPrice: 700.0),
      ItemResponse(
          id: 8,
          name: "Item 8",
          alias: "item-8",
          status: ItemStatus.public,
          pricePerDay: 800.0,
          refundableDeposit: 800.0,
          sellingPrice: 800.0),
    ];
  }

  Future<ItemDetailResponse?> getItem(int id) async {
    // Simulate a delay of 2 seconds (adjust as needed)
    await Future.delayed(Duration(milliseconds: 1700));

    // Fetch item from the server
    return ItemDetailResponse(
      id: id,
      name: "Item ${id}",
      alias: "item",
      description:
          "Description of item ${id}. This item is very good and handy for everyone. You can use it for many purposes. I will borrow it to you for a very good price. You will be happy with it. I promise.",
      parameters: "",
      status: ItemStatus.public,
      pricePerDay: 100.0,
      refundableDeposit: 100.0,
      sellingPrice: 2000.0,
      mainImage: ImageResponse(
          id: 1,
          name: "Item 1",
          path: "item-1.jpg",
          url:
              "https://bilder.obi.cz/7d81d317-d581-42c1-b7fe-896a3b36292a/prZZB/yDrill_aku_sroubovak_bosch.jpg",
          links: []),
      images: [
        ImageResponse(
          id: 1,
          name: "Item 1",
          path: "item-1.jpg",
          url:
              "https://bilder.obi.cz/7d81d317-d581-42c1-b7fe-896a3b36292a/prZZB/yDrill_aku_sroubovak_bosch.jpg",
          links: [],
        ),
        ImageResponse(
          id: 2,
          name: "Item 1",
          path: "item-1.jpg",
          url:
          "https://bilder.obi.cz/7d81d317-d581-42c1-b7fe-896a3b36292a/prZZB/yDrill_aku_sroubovak_bosch.jpg",
          links: [],
        ),
        ImageResponse(
          id: 3,
          name: "Item 1",
          path: "item-1.jpg",
          url:
          "https://bilder.obi.cz/7d81d317-d581-42c1-b7fe-896a3b36292a/prZZB/yDrill_aku_sroubovak_bosch.jpg",
          links: [],
        ),
        ImageResponse(
          id: 4,
          name: "Item 1",
          path: "item-1.jpg",
          url:
          "https://bilder.obi.cz/7d81d317-d581-42c1-b7fe-896a3b36292a/prZZB/yDrill_aku_sroubovak_bosch.jpg",
          links: [],
        ),
        ImageResponse(
          id: 5,
          name: "Item 1",
          path: "item-1.jpg",
          url:
          "https://bilder.obi.cz/7d81d317-d581-42c1-b7fe-896a3b36292a/prZZB/yDrill_aku_sroubovak_bosch.jpg",
          links: [],
        ),
        ImageResponse(
          id: 6,
          name: "Item 1",
          path: "item-1.jpg",
          url:
          "https://bilder.obi.cz/7d81d317-d581-42c1-b7fe-896a3b36292a/prZZB/yDrill_aku_sroubovak_bosch.jpg",
          links: [],
        ),
        ImageResponse(
          id: 7,
          name: "Item 1",
          path: "item-1.jpg",
          // Placeholder 75x75
          url: "https://via.placeholder.com/75x75.png",
          links: [],
        ),
      ],
      createdAt: DateTime.now().add(Duration(days: -10)),
    );
  }

  Future<ItemDetailResponse> createItem(ItemRequest request) async {
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
        pricePerDay: 100.0,
        refundableDeposit: 100.0,
        sellingPrice: 100.0,
        createdAt: DateTime.now());
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
