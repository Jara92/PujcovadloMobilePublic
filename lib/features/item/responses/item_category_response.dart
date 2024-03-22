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

  factory ItemCategoryResponse.fromJson(Map<String, Object> json) {
    return ItemCategoryResponse(
      id: json['id'] as int,
      name: json['name'] as String,
      alias: json['alias'] as String,
      parentId: json['parentId'] as int?,
      links: (json['_links'] as List<Object>)
          .map((e) => LinkResponse.fromJson(e as Map<String, Object>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, name, alias, parentId];
}
