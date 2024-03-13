import 'package:flutter/foundation.dart';
import '../enums/item_status.dart';

class ItemResponse {
  int id;

  String name;

  String alias;

  ItemStatus status;

  double pricePerDay;

  double? refundableDeposit;

  double? sellingPrice;

  //late UserResponse owner;

  //late ImageResponse? mainImage;

  //IList<ImageResponse> images = new List<ImageResponse>();

  //IList<LinkResponse> links = new List<LinkResponse>();

  ItemResponse({
    required this.id,
    required this.name,
    required this.alias,
    required this.status,
    required this.pricePerDay,
    this.refundableDeposit,
    this.sellingPrice,
    //required this.owner,
    //this.mainImage,
    //this.images,
    //this.links
  });

  factory ItemResponse.fromJson(Map<String, Object> json) {
    return ItemResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      alias: json['alias'] as String,
      status: ItemStatusExtension.fromValue(json['status'] as int),
      pricePerDay: json['pricePerDay'] as double,
      refundableDeposit: json['refundableDeposit'] as double?,
      sellingPrice: json['sellingPrice'] as double?,
    );
  }
}
