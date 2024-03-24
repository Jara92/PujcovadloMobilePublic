import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_list_tile_widget.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_list_widget.dart';

import '../bloc/item_list/item_list_bloc.dart';
import 'item_detail_view.dart';

class ItemListView extends StatefulWidget {
  ItemListView({super.key});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemListBloc>(
      create: (context) {
        var bloc = ItemListBloc();
        bloc.add(SearchTextUpdated(searchText: ''));
        return bloc;
      },
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SafeArea(
              child: BlocConsumer<ItemListBloc, ItemListState>(
                listener: (context, state) {},
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
                              message: 'Advanced search',
                              child: IconButton(
                                isSelected: false,
                                onPressed: () {
                                  setState(() {
                                    //isDark = !isDark;
                                  });
                                },
                                icon: const Icon(Icons.manage_search),
                                selectedIcon: const Icon(Icons.manage_search),
                              ),
                            )
                          ],
                          padding: const MaterialStatePropertyAll<EdgeInsets>(
                              EdgeInsets.symmetric(horizontal: 16.0)),
                          onChanged: (value) {
                            //print("onChanged");
                            BlocProvider.of<ItemListBloc>(context)
                                .add(SearchTextUpdated(searchText: value));
                          },
                          hintText: context.loc.what_are_you_looking_for,
                        ),
                      ),
                      state.isLoading
                          ? const Expanded(
                              child: Center(child: CircularProgressIndicator()))
                          : Expanded(
                              child: ItemListWidget(
                                items: state.items,
                                isLastPage: state.isLastPage,
                                itemBuilder: (context, item) =>
                                    ItemListTileWidget(item: item),
                                onItemTap: (ItemResponse item) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ItemDetailView(item: item)));
                                },
                                onLoadMore: (index) => context
                                    .read<ItemListBloc>()
                                    .add(const LoadMoreEvent()),
                              ),
                            ),
                    ],
                  );
                },
              ),
            )),
        bottomNavigationBar: const MainBottomNavigationBar(),
      ),
    );
  }
}
