import 'dart:convert';

import 'package:pujcovadlo_client/core/requests/image_request.dart';

class ItemRequest{
  int? id;
  String? name;
  String? description;

  double? pricePerDay;
  double? refundableDeposit;
  double? sellingPrice;

  List<ImageRequest> images;
  ImageRequest? mainImage;
  int? mainImageId;
  List<String> tags;
  List<int> categories;

  String? createImageLink;
  String? updateLink;

  ItemRequest({
    this.id,
    this.name,
    this.description,
    this.pricePerDay,
    this.refundableDeposit,
    this.sellingPrice,
    this.images = const [],
    this.mainImage,
    this.mainImageId,
    this.tags = const [],
    this.categories = const [],
    this.createImageLink,
    this.updateLink,
  });

  dynamic toJson() {
    return jsonEncode(<String, dynamic>{
      "Id": id,
      "Name": name,
      "Description": description,
      "PricePerDay": pricePerDay,
      "RefundableDeposit": refundableDeposit,
      "SellingPrice": sellingPrice,
      "MainImageId": mainImageId,
      "Tags": tags,
      "Categories": categories,
    });
  }
}