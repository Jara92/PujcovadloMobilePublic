import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/common/bloc/application_bloc.dart';
import 'package:pujcovadlo_client/common/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/common/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/item/widgets/item_list_widget.dart';
import 'package:pujcovadlo_client/item/services/item_service.dart';
import 'package:get_it/get_it.dart';

import '../bloc/item_list/item_list_bloc.dart';

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
