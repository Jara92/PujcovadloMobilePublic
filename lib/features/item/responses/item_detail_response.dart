import 'dart:core';
import 'package:pujcovadlo_client/core/responses/image_response.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';

class ItemDetailResponse extends ItemResponse {
  String description;

  String parameters;

  List<ImageResponse> images;

  //List<ItemCategoryResponse> categories;

  //List<ItemTagResponse> tags;

  DateTime createdAt;

  DateTime? updatedAt;

  DateTime? approvedAt;

  ItemDetailResponse({
    required this.description,
    required this.parameters,
    //required this.categories,
    //required this.tags,
    required this.createdAt,
    this.images = const [],
    this.updatedAt,
    this.approvedAt,
    required super.id,
    required super.name,
    required super.alias,
    required super.status,
    required super.pricePerDay,
    required super.refundableDeposit,
    required super.sellingPrice,
    required super.owner,
    super.latitude,
    super.longitude,
    super.mainImage,
  });
}
