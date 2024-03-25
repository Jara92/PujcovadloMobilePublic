import 'dart:core';

import 'package:equatable/equatable.dart';

class ItemTagResponse extends Equatable {
  final int id;

  final String name;

  const ItemTagResponse({
    required this.id,
    required this.name,
  });

  factory ItemTagResponse.fromJson(Map<String, dynamic> json) {
    return ItemTagResponse(
      id: json['Id'] as int,
      name: json['Name'].toString(),
    );
  }

  @override
  List<Object?> get props => [id, name];
}
