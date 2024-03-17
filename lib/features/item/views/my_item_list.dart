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
  MyItemList({super.key});

  @override
  State<MyItemList> createState() => _MyItemListState();
}

class _MyItemListState extends State<MyItemList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyItemListBloc>(
      create: (context) {
        var bloc = MyItemListBloc();
        bloc.add(const InitialEvent());
        return bloc;
      },
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SafeArea(
                child: BlocConsumer<MyItemListBloc, MyItemListState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: TextField(
                            onChanged: (value) {
                              //print("onChanged");
                              BlocProvider.of<MyItemListBloc>(context)
                                  .add(SearchTextUpdated(searchText: value));
                            },
                            decoration: InputDecoration(
                              //border: OutlineInputBorder(),
                              icon: const Icon(Icons.search),
                              hintText: context.loc.what_are_you_looking_for,
                            ),
                          ),
                        ),
                        // TODO: ADD SCREEN FOR NO ITEMS
                        state.isLoading
                            ? const Expanded(
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : Expanded(
                                child: ItemListWidget(
                                  items: state.items,
                                  itemBuilder: (context, item) =>
                                      MyItemListTileWidget(item: item),
                                  onItemTap: (ItemResponse item) {
                                    // TODO: link to item edit
                                  },
                                ),
                              ),
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
}
