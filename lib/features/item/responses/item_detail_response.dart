import 'dart:core';

import 'package:pujcovadlo_client/core/responses/image_response.dart';
import 'package:pujcovadlo_client/core/responses/link_response.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';
import 'package:pujcovadlo_client/features/item/enums/item_status.dart';
import 'package:pujcovadlo_client/features/item/responses/item_category_response.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/responses/item_tag_response.dart';

class ItemDetailResponse extends ItemResponse {
  String description;

  String parameters;

  List<ImageResponse> images;

  List<ItemCategoryResponse> categories;

  List<ItemTagResponse> tags;

  DateTime createdAt;

  DateTime? updatedAt;

  DateTime? approvedAt;

  ItemDetailResponse({
    required this.description,
    required this.parameters,
    required this.categories,
    required this.tags,
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
    super.links = const [],
  });

  factory ItemDetailResponse.fromJson(Map<String, dynamic> json) {
    return ItemDetailResponse(
      id: json['Id'] as int,
      name: json['Name'] as String,
      description: json['Description'] as String,
      parameters: json['Parameters'] as String,
      categories: (json['Categories'] as List)
          .map((e) => ItemCategoryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      tags: (json['Tags'] as List)
          .map((e) => ItemTagResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      alias: json['Alias'] as String,
      status: ItemStatusExtension.fromValue(json['Status'] as int),
      pricePerDay: json['PricePerDay']?.toDouble(),
      refundableDeposit: json['RefundableDeposit']?.toDouble(),
      sellingPrice: json['SellingPrice']?.toDouble(),
      owner: UserResponse.fromJson(json['Owner'] as Map<String, dynamic>),
      latitude: json['Latitude']?.toDouble(),
      longitude: json['Longitude']?.toDouble(),
      mainImage: json['MainImage'] != null
          ? ImageResponse.fromJson(json['MainImage'] as Map<String, dynamic>)
          : null,
      images: (json['Images'] as List)
          .map((e) => ImageResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['CreatedAt'].toString()),
      updatedAt: json['UpdatedAt'] != null
          ? DateTime.parse(json['UpdatedAt'].toString())
          : null,
      approvedAt: json['ApprovedAt'] != null
          ? DateTime.parse(json['ApprovedAt'].toString())
          : null,
      links: (json['_links'] as List)
          .map((e) => LinkResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
