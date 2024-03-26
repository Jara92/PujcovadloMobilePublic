import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_placeholder_image.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemMainImage extends StatelessWidget {
  final ItemResponse item;
  final double width;
  final double height;

  const ItemMainImage(
      {required this.item, this.width = 75, this.height = 75, super.key});

  @override
  Widget build(BuildContext context) {
    if (item.mainImage?.url == null) {
      return ItemPlaceholderImage(width: width, height: height);
    }

    return FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: item.mainImage?.url ?? '',
      width: width,
      height: height,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, error, stackTrace) =>
          ItemPlaceholderImage(width: width, height: height),
    );
  }
}
