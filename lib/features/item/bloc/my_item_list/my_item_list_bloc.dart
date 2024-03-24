import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';
import 'package:pujcovadlo_client/features/item/filters/item_filter.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';

export 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';

part 'my_item_list_event.dart';
part 'my_item_list_state.dart';

class MyItemListBloc extends ListBloc<ItemResponse, MyItemListState> {
  final ItemService itemService = GetIt.instance.get<ItemService>();
  late final ItemFilter myItemsFilter;

  MyItemListBloc() : super(const InitialState()) {
    on<SearchTextUpdated>(
      _onSearchTextUpdated,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  @override
  Future<void> onInitialEvent(
      InitialEvent<ItemResponse> event, Emitter<MyItemListState> emit) async {
    // todo: get real user id
    myItemsFilter = ItemFilter(ownerId: "13f11f92-6c4d-44e2-b7a8-3609d80a439c");

    super.onInitialEvent(event, emit);
  }

  void _onSearchTextUpdated(
      SearchTextUpdated event, Emitter<MyItemListState> emit) {
    emit(state.copyWith(search: event.searchText));
    myItemsFilter.search = event.searchText;

    add(const ReloadItemsEvent());
  }

  @override
  Future<void> onReloadItemsEvent(
      ListEvent<ItemResponse> event, Emitter<MyItemListState> emit) async {
    return reloadItems(
        event, emit, () => itemService.getItems(filter: myItemsFilter));
  }

  @override
  Future<void> onLoadMoreEvent(
      LoadMoreEvent<ItemResponse> event, Emitter<MyItemListState> emit) async {
    return loadMore(
        event, emit, () => itemService.getItemsByUri(nextPageLink!));
  }
}
