import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/item/responses/item_detail_response.dart';

import '../../services/item_service.dart';

part 'item_detail_event.dart';
part 'item_detail_state.dart';

class ItemDetailBloc extends Bloc<ItemDetailEvent, ItemDetailState> {
  final ItemService _itemService = GetIt.instance.get<ItemService>();

  ItemDetailBloc() : super(const ItemDetailInitial()) {
    on<LoadItemDetail>((event, emit) async {
      int itemid = event.itemId;

      emit (const ItemDetailLoading());

      try {
        var item = await _itemService.getItem(itemid);

        if (item != null) {
          emit(ItemDetailLoaded(item: item));
        } else {
          emit(const ItemDetailNotFound());
        }
      }
      on Exception catch (e) {
        emit(ItemDetailFailed(error: e));
      }
    });
  }
}
