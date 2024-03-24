import 'package:flutter/material.dart';
import 'package:paginated_list/paginated_list.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';

typedef ItemCallback = void Function(ItemResponse item);
typedef ItemBuilder = Widget Function(BuildContext context, ItemResponse item);
typedef LoadMoreCallback = void Function(int index);

class ItemListWidget extends StatelessWidget {
  final List<ItemResponse> items;
  final bool isLastPage;
  final ItemCallback onItemTap;
  final ItemBuilder itemBuilder;
  final LoadMoreCallback onLoadMore;

  const ItemListWidget({
    super.key,
    required this.items,
    required this.isLastPage,
    required this.itemBuilder,
    required this.onItemTap,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedList<ItemResponse>(
      loadingIndicator: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      items: items,
      isRecentSearch: false,
      isLastPage: isLastPage,
      onLoadMore: (index) => onLoadMore(index),
      builder: (
        item,
        index,
      ) =>
          GestureDetector(
        onTap: () {
          onItemTap(item);
        },
        child: itemBuilder(
          context,
          item,
        ),
      ),
    );
  }
}
