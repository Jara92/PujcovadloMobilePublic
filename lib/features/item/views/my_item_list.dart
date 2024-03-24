import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/item/bloc/my_item_list/my_item_list_bloc.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/views/item_create_view.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_list_widget.dart';
import 'package:pujcovadlo_client/features/item/widgets/my_item_list_tile_widget.dart';

class MyItemList extends StatefulWidget {
  const MyItemList({super.key});

  @override
  State<MyItemList> createState() => _MyItemListState();
}

class _MyItemListState extends State<MyItemList> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyItemListBloc>(
      create: (context) => MyItemListBloc()..add(const InitialEvent()),
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SafeArea(
                child: BlocBuilder<MyItemListBloc, MyItemListState>(
                  builder: (context, state) {
                    Widget mainContent = const SizedBox.shrink();

                    if (state.status == ListStateEnum.loaded) {
                      mainContent = _buildItemList(context, state);
                    }

                    if (state.status == ListStateEnum.loading) {
                      mainContent = const Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    }

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
    // TODO: ADD SCREEN FOR NO ITEMS
    return Expanded(
      child: ItemListWidget(
        items: state.items,
        isLastPage: state.isLastPage,
        itemBuilder: (context, item) => MyItemListTileWidget(item: item),
        onItemTap: (ItemResponse item) {
          // TODO: link to item edit
        },
        onLoadMore: (index) =>
            context.read<MyItemListBloc>().add(const LoadMoreEvent()),
      ),
    );
  }
}
