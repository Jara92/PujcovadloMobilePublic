import 'package:pujcovadlo_client/core/responses/image_response.dart';
import 'package:pujcovadlo_client/core/responses/link_response.dart';
import 'package:pujcovadlo_client/features/authentication/responses/user_response.dart';
import 'package:pujcovadlo_client/features/loan/enums/loan_status.dart';

class LoanResponse {
  int id;

  LoanStatus status;

  DateTime from;

  DateTime to;

  int days;

  double pricePerDay;

  double expectedPrice;

  double? refundableDeposit;

  String? tenantNote;

  UserResponse tenant;

  UserResponse owner;

  String itemName;

  ImageResponse? itemImage;

  //List<ReviewResponse> reviews;

  List<LinkResponse> links;

  LoanResponse({
    required this.id,
    required this.status,
    required this.from,
    required this.to,
    required this.days,
    required this.pricePerDay,
    required this.expectedPrice,
    this.refundableDeposit,
    this.tenantNote,
    required this.tenant,
    required this.owner,
    required this.itemName,
    this.itemImage,
    //this.reviews,
    this.links = const [],
  });

  factory LoanResponse.fromJson(Map<String, dynamic> json) {
    return LoanResponse(
      id: json['Id'] as int,
      status: LoanStatusExtension.fromValue(json['Status'] as int),
      from: DateTime.parse(json['From'].toString()),
      to: DateTime.parse(json['To'].toString()),
      days: json['Days'] as int,
      pricePerDay: json['PricePerDay'].toDouble(),
      expectedPrice: json['ExpectedPrice'].toDouble(),
      refundableDeposit: json['RefundableDeposit']?.toDouble(),
      tenantNote: json['TenantNote']?.toString(),
      tenant: UserResponse.fromJson(json['Tenant'] as Map<String, dynamic>),
      owner: UserResponse.fromJson(json['Owner'] as Map<String, dynamic>),
      itemName: json['ItemName'].toString(),
      itemImage: json['ItemImage'] != null
          ? ImageResponse.fromJson(json['ItemImage'] as Map<String, dynamic>)
          : null,
      //reviews: (json['Reviews'] as List<dynamic>)
      //    .map((e) => ReviewResponse.fromJson(e as Map<String, dynamic>))
      //    .toList(),
      links: (json['_links'] as List<dynamic>)
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
}
