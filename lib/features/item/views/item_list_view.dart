import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/loading_next_page_error.dart';
import 'package:pujcovadlo_client/core/widgets/errors/not_found_error.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_list_tile_widget.dart';

import '../bloc/item_list/item_list_bloc.dart';
import 'item_detail_view.dart';

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  late final ItemListBloc _bloc;
  late final TextEditingController searchController;
  late final PagingController<String, ItemResponse> _pagingController;

  @override
  void initState() {
    super.initState();

    // Create a new bloc
    _bloc = ItemListBloc()..add(const InitialEvent());

    // Init controllers
    searchController = TextEditingController();
    _pagingController = PagingController(firstPageKey: "");

    _pagingController.addPageRequestListener(
        (pageKey) => _bloc.add(LoaditemsEvent(pageKey)));
  }

  @override
  void dispose() {
    searchController.dispose();
    _pagingController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemListBloc>(
      create: (context) => _bloc,
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SafeArea(
                child: BlocConsumer<ItemListBloc, ItemListState>(
                  listener: (context, state) {
                    // New items loaded?
                    if (state.status == ListStateEnum.loaded) {
                      // Append items to the list as the last page of the list
                      if (state.isLastPage) {
                        _pagingController.appendLastPage(state.items);
                      }
                      // Append items to the list as a new page
                      else {
                        _pagingController.appendPage(
                            state.items, state.nextPageLink);
                      }
                    }

                    // Error occurred?
                    if (state.status == ListStateEnum.error) {
                      _pagingController.error = state.error;
                    }

                    // Initial state? Should refresh the list
                    if (state.status == ListStateEnum.initial) {
                      _pagingController.refresh();
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: SearchBar(
                            leading: const Icon(Icons.search),
                            trailing: <Widget>[
                              Tooltip(
                                message: context.loc.advanced_search,
                                child: IconButton(
                                  isSelected: false,
                                  onPressed: () {},
                                  icon: const Icon(Icons.manage_search),
                                  selectedIcon: const Icon(Icons.manage_search),
                                ),
                              )
                            ],
                            padding: const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16.0)),
                            onChanged: (value) =>
                                BlocProvider.of<ItemListBloc>(context)
                                    .add(SearchTextUpdated(searchText: value)),
                            hintText: context.loc.what_are_you_looking_for,
                          ),
                        ),
                        _buildItemList(context, state),
                      ],
                    );
                  },
                ),
              )),
          bottomNavigationBar: const MainBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _bloc.add(const UpdateLocationEvent()),
            child: const Icon(Icons.location_searching),
          )),
    );
  }

  Widget _buildItemList(BuildContext context, ItemListState state) {
    return Expanded(
      child: PagedListView<String, ItemResponse>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<ItemResponse>(
          firstPageErrorIndicatorBuilder: (_) => OperationError(
            onRetry: _pagingController.refresh,
          ),
          noItemsFoundIndicatorBuilder: (_) => NotFoundError(
            title: context.loc.no_items_found,
            message: context.loc.no_items_found_message,
          ),
          newPageErrorIndicatorBuilder: (_) => LoadingNextPageErrorWidget(
            onRetry: _pagingController.retryLastFailedRequest,
          ),
          itemBuilder: (context, item, index) => GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ItemDetailView(item: item))),
            child: ItemListTileWidget(item: item),
          ),
        ),
      ),
    );
  }
}
