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
                        margin: const EdgeInsets.only(bottom: 5),
                        child: TextField(
                          onChanged: (value) {
                            //print("onChanged");
                            BlocProvider.of<ItemListBloc>(context)
                                .add(SearchTextUpdated(searchText: value));
                          },
                          decoration: InputDecoration(
                            //border: OutlineInputBorder(),
                            icon: const Icon(Icons.search),
                            hintText: context.loc.what_are_you_looking_for,
                          ),
                        ),
                      ),
                      state.isLoading
                          ? const Expanded(
                              child: Center(child: CircularProgressIndicator()))
                          : Expanded(
                              child: ItemListWidget(
                                items: state.items,
                                itemBuilder: (context, item) =>
                                    ItemListTileWidget(item: item),
                                onItemTap: (ItemResponse item) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ItemDetailView(
                                                itemId: item.id,
                                              )));
                                },
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
