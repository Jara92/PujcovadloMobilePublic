import 'package:pujcovadlo_client/features/item/responses/item_tag_response.dart';

class ItemTagService {
  Future<List<ItemTagResponse>> getTags(String? search) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      ItemTagResponse(id: 1, name: "Elektrická vrtačka"),
      ItemTagResponse(id: 2, name: "Kladivo"),
      ItemTagResponse(id: 3, name: "Pila"),
      ItemTagResponse(id: 4, name: "Šroubovák"),
      ItemTagResponse(id: 5, name: "Klíč"),
      ItemTagResponse(id: 6, name: "Příklepová vrtačka"),
      ItemTagResponse(id: 7, name: "Pneumatický kladivo"),
      ItemTagResponse(id: 8, name: "Pneumatická pistole"),
      ItemTagResponse(id: 9, name: "Pneumatický šroubovák"),
      ItemTagResponse(id: 10, name: "Pneumatický klíč"),
      ItemTagResponse(id: 11, name: "Pneumatická příklepová vrtačka"),
      ItemTagResponse(id: 12, name: "Pneumatická pistole"),
      ItemTagResponse(id: 13, name: "Pneumatický šroubovák"),
    ]
        .where((element) =>
            element.name.toLowerCase().contains(search!.toLowerCase()))
        .toList();
  }
}
