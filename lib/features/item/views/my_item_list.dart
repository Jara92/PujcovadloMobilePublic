import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/loading_next_page_error.dart';
import 'package:pujcovadlo_client/core/widgets/errors/not_found_error.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/item/bloc/my_item_list/my_item_list_bloc.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/views/item_create_view.dart';
import 'package:pujcovadlo_client/features/item/widgets/my_item_list_tile_widget.dart';

class MyItemList extends StatefulWidget {
  const MyItemList({super.key});

  @override
  State<MyItemList> createState() => _MyItemListState();
}

class _MyItemListState extends State<MyItemList> {
  late final MyItemListBloc _bloc;
  late final TextEditingController searchController;
  late final PagingController<String, ItemResponse> _pagingController;

  @override
  void initState() {
    super.initState();

    // Create a new bloc
    _bloc = MyItemListBloc()..add(const InitialEvent());

    // Init controllers
    searchController = TextEditingController();
    _pagingController = PagingController(firstPageKey: "");

    _pagingController.addPageRequestListener(
        (pageKey) => _bloc.add(LoadMoreItemsEvent(pageKey)));
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
    return BlocProvider<MyItemListBloc>(
      create: (context) => _bloc,
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SafeArea(
                child: BlocConsumer<MyItemListBloc, MyItemListState>(
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
                    Widget mainContent = const SizedBox.shrink();

                    mainContent = _buildItemList(context, state);

                    return Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: SearchBar(
                              controller: searchController,
                              leading: const Icon(Icons.search),
                              trailing: <Widget>[
                                Tooltip(
                                  message: context.loc.clear_search,
                                  child: IconButton(
                                    isSelected: false,
                                    onPressed: () {
                                      // clear value
                                      searchController.clear();

                                      // trigger on changed
                                      BlocProvider.of<MyItemListBloc>(context)
                                          .add(const SearchTextUpdated(
                                              searchText: ""));
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                )
                              ],
                              padding:
                                  const MaterialStatePropertyAll<EdgeInsets>(
                                      EdgeInsets.symmetric(horizontal: 16.0)),
                              onChanged: (value) =>
                                  BlocProvider.of<MyItemListBloc>(context).add(
                                      SearchTextUpdated(searchText: value)),
                              hintText: context.loc.searching_in_my_items,
                            )),
                        mainContent,
                      ],
                    );
                  },
                ),
              )),
          bottomNavigationBar: const MainBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ItemCreateView()));
            },
            child: const Icon(Icons.add),
          )),
    );
  }

  Widget _buildItemList(BuildContext context, MyItemListState state) {
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
                builder: (context) => ItemCreateView(itemId: item.id))),
            child: MyItemListTileWidget(item: item),
          ),
        ),
      ),
    );
  }
}
