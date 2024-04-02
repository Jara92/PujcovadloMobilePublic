import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/item/responses/item_detail_response.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';

part 'item_detail_event.dart';
part 'item_detail_state.dart';

class ItemDetailBloc extends Bloc<ItemDetailEvent, ItemDetailState> {
  final ItemService _itemService = GetIt.instance.get<ItemService>();

  ItemDetailBloc() : super(const ItemDetailInitial()) {
    on<LoadItemDetail>(_onLoadItemDetail);
  }

  Future<void> _onLoadItemDetail(
      LoadItemDetail event, Emitter<ItemDetailState> emit) async {
    // Emit loading state
    emit(const ItemDetailLoading());

    try {
      ItemDetailResponse? item;

      // Load item by uri if available
      if (event.item != null && event.item!.selfLink != null) {
        item = await _itemService.getItemByUri(event.item!.selfLink!);
      }
      // Load item by id if available
      else if (event.itemId != null) {
        item = await _itemService.getItemById(event.itemId!);
      }

      // Emit loaded state if item was found
      if (item != null) {
        item.distance = event.item?.distance;
        emit(ItemDetailLoaded(item: item));
      }
      // Emit not found state if item was not found
      else {
        emit(const ItemDetailNotFound());
      }
    }
    // Emit failed state if an exception was thrown
    on Exception catch (e) {
      emit(ItemDetailFailed(error: e));
    }
  }
}
