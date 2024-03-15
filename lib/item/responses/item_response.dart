import 'package:flutter/foundation.dart';
import '../enums/item_status.dart';
import 'image_response.dart';

class ItemResponse {
  int id;

  String name;

  String alias;

  ItemStatus status;

  double pricePerDay;

  double? refundableDeposit;

  double? sellingPrice;

  double? latitude;

  double? longitude;

  //late UserResponse owner;

  ImageResponse? mainImage;

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
    this.latitude,
    this.longitude,
    //required this.owner,
    this.mainImage,
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
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      mainImage: json['mainImage'] != null
          ? ImageResponse.fromJson(json['mainImage'] as Map<String, Object>)
          : null,
    );
  }
}
