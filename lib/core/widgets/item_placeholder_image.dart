import 'package:flutter/material.dart';

class ItemPlaceholderImage extends StatelessWidget {
  const ItemPlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "images/item_placeholder.png",
      /*     width: 75,
      height: 75,*/
      fit: BoxFit.contain,
    );
  }
}
