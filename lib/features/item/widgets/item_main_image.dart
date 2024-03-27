import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/core/responses/image_response.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_placeholder_image.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemMainImage extends StatelessWidget {
  final ImageResponse? image;
  final double width;
  final double height;

  const ItemMainImage(
      {this.image, this.width = 100, this.height = 100, super.key});

  @override
  Widget build(BuildContext context) {
    if (image?.url == null) {
      return const ItemPlaceholderImage();
    }

    return FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: image?.url ?? '',
      width: width,
      height: height,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, error, stackTrace) =>
          const ItemPlaceholderImage(),
    );
  }
}
