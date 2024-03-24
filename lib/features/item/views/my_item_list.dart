import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/item/bloc/my_item_list/my_item_list_bloc.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/views/item_create_view.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_list_widget.dart';
import 'package:pujcovadlo_client/features/item/widgets/my_item_list_tile_widget.dart';

class MyItemList extends StatelessWidget {
  const MyItemList({super.key});

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

                    if (state.status == MyItemListStateEnum.loaded) {
                      mainContent = _buildItemList(context, state);
                    }

                    if (state.status == MyItemListStateEnum.loading) {
                      mainContent = const Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    }

                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: TextField(
                            onChanged: (value) {
                              BlocProvider.of<MyItemListBloc>(context)
                                  .add(SearchTextUpdated(searchText: value));
                            },
                            decoration: InputDecoration(
                              icon: const Icon(Icons.search),
                              hintText: context.loc.what_are_you_looking_for,
                            ),
                          ),
                        ),
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
        // todo
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
