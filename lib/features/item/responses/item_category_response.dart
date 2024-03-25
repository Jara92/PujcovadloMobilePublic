import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:pujcovadlo_client/core/responses/link_response.dart';

class ItemCategoryResponse extends Equatable {
  final int id;

  final String name;

  final String alias;

  final int? parentId;

  final List<LinkResponse> links;

  const ItemCategoryResponse({
    required this.id,
    required this.name,
    required this.alias,
    this.parentId,
    this.links = const [],
  });

  factory ItemCategoryResponse.fromJson(Map<String, dynamic> json) {
    return ItemCategoryResponse(
      id: json['Id'] as int,
      name: json['Name'] as String,
      alias: json['Alias'] as String,
      parentId: json['ParentId'] as int?,
      links: (json['_links'] as List<dynamic>)
          .map((e) => LinkResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object> get props => [id, name, alias];
}
