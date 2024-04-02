import 'package:pujcovadlo_client/core/responses/image_response.dart';
import 'package:pujcovadlo_client/core/responses/link_response.dart';
import 'package:pujcovadlo_client/features/item/enums/item_status.dart';
import 'package:pujcovadlo_client/features/profiles/responses/user_response.dart';

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

  double? distance;

  UserResponse owner;

  ImageResponse? mainImage;

  List<LinkResponse> links;

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
    this.distance,
    required this.owner,
    this.mainImage,
    //this.images,
    this.links = const [],
  });

  factory ItemResponse.fromJson(Map<String, dynamic> json) {
    return ItemResponse(
      id: json['Id'] as int,
      name: json['Name'] as String,
      alias: json['Alias'] as String,
      status: ItemStatusExtension.fromValue(json['Status'] as int),
      pricePerDay: json['PricePerDay']?.toDouble(),
      refundableDeposit: json['RefundableDeposit']?.toDouble(),
      sellingPrice: json['SellingPrice']?.toDouble(),
      owner: UserResponse.fromJson(json['Owner'] as Map<String, dynamic>),
      latitude: json['Latitude']?.toDouble(),
      longitude: json['Longitude']?.toDouble(),
      distance: json['Distance']?.toDouble(),
      mainImage: json['MainImage'] != null
          ? ImageResponse.fromJson(json['MainImage'] as Map<String, dynamic>)
          : null,
      links: (json['_links'] as List)
          .map((e) => LinkResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String? get selfLink {
    return links
        .where((element) => element.rel == LinkRels.self)
        .firstOrNull
        ?.href;
  }

  String? get updateLink {
    return links
        .where((element) => element.rel == LinkRels.update)
        .firstOrNull
        ?.href;
  }

  String? get deleteLink {
    return links
        .where((element) => element.rel == LinkRels.delete)
        .firstOrNull
        ?.href;
  }

  String? get createImageLink {
    return links
        .where((element) => element.rel == LinkRels.createImage)
        .firstOrNull
        ?.href;
  }
}
