import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';
import 'package:pujcovadlo_client/features/item/filters/item_filter.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';

export 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';

part 'item_list_event.dart';
part 'item_list_state.dart';

class ItemListBloc extends ListBloc<ItemResponse, ItemListState> {
  final ItemService itemService = GetIt.instance.get<ItemService>();
  late final ItemFilter itemsFilter = ItemFilter();

  ItemListBloc() : super(const InitialState()) {
    on<SearchTextUpdated>(
      _onSearchTextUpdated,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  @override
  Future<void> onLoadItemsEvent(
      LoaditemsEvent<ItemResponse> event, Emitter<ItemListState> emit) async {
    // Load first page
    if (state.status == ListStateEnum.initial ||
        // First request failed and there is no next page link
        (state.status == ListStateEnum.error && event.nextPageLink.isEmpty)) {
      return loadItems(
          event, emit, () => itemService.getItems(filter: itemsFilter));
    }

    // Load another page using next page link
    return loadItems(
        event, emit, () => itemService.getItemsByUri(event.nextPageLink));
  }

  void _onSearchTextUpdated(
      SearchTextUpdated event, Emitter<ItemListState> emit) {
    // Update search text and status to refreshing
    emit(state.copyWith(
        search: event.searchText, status: ListStateEnum.initial));

    // Update filter
    itemsFilter.search = event.searchText;
  }
}
