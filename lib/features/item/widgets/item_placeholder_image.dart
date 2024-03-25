import 'package:flutter/material.dart';

class ItemPlaceholderImage extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;

  const ItemPlaceholderImage(
      {this.fit = BoxFit.contain,
      this.width = 75,
      this.height = 75,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "images/item_placeholder.png",
      width: width,
      height: height,
      fit: fit,
    );
  }
}
