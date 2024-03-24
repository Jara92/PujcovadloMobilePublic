import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/responses/item_detail_response.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';

import '../../services/item_service.dart';

part 'item_detail_event.dart';
part 'item_detail_state.dart';

class ItemDetailBloc extends Bloc<ItemDetailEvent, ItemDetailState> {
  final ItemService _itemService = GetIt.instance.get<ItemService>();

  ItemDetailBloc() : super(const ItemDetailInitial()) {
    on<LoadItemDetail>((event, emit) async {
      emit (const ItemDetailLoading());

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
