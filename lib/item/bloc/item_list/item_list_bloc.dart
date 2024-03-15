import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/item/responses/item_response.dart';
import 'package:pujcovadlo_client/item/services/item_service.dart';

part 'item_list_event.dart';
part 'item_list_state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  List<ItemResponse> items = <ItemResponse>[];
  final ItemService itemService = GetIt.instance.get<ItemService>();

  ItemListBloc() : super(const ItemListInitial(isLoading: true, items: <ItemResponse>[])) {
    on<SearchTextUpdated>((event, emit) async {

      //print('SearchTextUpdated');

      emit(ItemListLoading(isLoading: true));

      // todo: search
      var items = await itemService.getItems();

      //this.items.addAll(items);

      emit(ItemListLoaded(items: items, isLoading: false));

    });
  }
}
