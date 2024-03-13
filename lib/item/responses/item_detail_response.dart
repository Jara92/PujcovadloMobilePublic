import 'package:pujcovadlo_client/item/responses/item_response.dart';

class ItemDetailResponse extends ItemResponse {
  ItemDetailResponse(
      {required super.id,
      required super.name,
      required super.alias,
      required super.status,
      required super.pricePerDay,
      required super.refundableDeposit,
      required super.sellingPrice});
}
