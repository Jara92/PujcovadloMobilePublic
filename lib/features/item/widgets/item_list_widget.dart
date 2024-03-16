import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';

typedef ItemCallback = void Function(ItemResponse item);
typedef ItemBuilder = Widget Function(BuildContext context, ItemResponse item);

class ItemListWidget extends StatelessWidget {
  final Iterable<ItemResponse> items;
  final ItemCallback onItemTap;
  final ItemBuilder itemBuilder;

  const ItemListWidget(
      {super.key,
      required this.items,
      required this.itemBuilder,
      required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items.elementAt(index);
        return GestureDetector(
          onTap: () {
            onItemTap(item);
          },
          child: itemBuilder(
            context,
            item,
          ),
        );
      },
    );
  }
}
