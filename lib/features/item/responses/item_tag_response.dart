import 'dart:core';

import 'package:equatable/equatable.dart';

class ItemTagResponse extends Equatable {
  final int id;

  final String name;

  const ItemTagResponse({
    required this.id,
    required this.name,
  });

  factory ItemTagResponse.fromJson(Map<String, Object> json) {
    return ItemTagResponse(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
