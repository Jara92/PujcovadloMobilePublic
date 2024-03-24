import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:paginated_list/paginated_list.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';

typedef ItemCallback = void Function(ItemResponse item);
typedef ItemBuilder = Widget Function(BuildContext context, ItemResponse item);
typedef LoadMoreCallback = void Function(int index);

class ItemListWidget extends StatefulWidget {
  final List<ItemResponse> items;
  final bool isLastPage;
  final ItemCallback onItemTap;
  final ItemBuilder itemBuilder;
  final LoadMoreCallback onLoadMore;
  final PagingController<String, ItemResponse> pagingController;

  const ItemListWidget({
    super.key,
    required this.items,
    required this.isLastPage,
    required this.itemBuilder,
    required this.onItemTap,
    required this.onLoadMore,
    required this.pagingController,
  });

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        PagedSliverGrid<String, ItemResponse>(
          pagingController: widget.pagingController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 100 / 150,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
          ),
          builderDelegate: PagedChildBuilderDelegate<ItemResponse>(
            itemBuilder: (context, item, index) => GestureDetector(
              onTap: () => widget.onItemTap(item),
              child: widget.itemBuilder(
                context,
                item,
              ),
            ),
          ),
        )
      ],
    );

    return PaginatedList<ItemResponse>(
      loadingIndicator: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      items: widget.items,
      isRecentSearch: false,
      isLastPage: widget.isLastPage,
      onLoadMore: (index) => widget.onLoadMore(index),
      builder: (
        item,
        index,
      ) =>
          GestureDetector(
        onTap: () {
          widget.onItemTap(item);
        },
        child: widget.itemBuilder(
          context,
          item,
        ),
      ),
    );
  }
}
