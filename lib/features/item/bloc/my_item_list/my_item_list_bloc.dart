import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';
import 'package:pujcovadlo_client/features/authentication/services/authentication_service.dart';
import 'package:pujcovadlo_client/features/item/filters/item_filter.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';

export 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';

part 'my_item_list_event.dart';
part 'my_item_list_state.dart';

class MyItemListBloc extends ListBloc<ItemResponse, MyItemListState> {
  final ItemService itemService = GetIt.instance.get<ItemService>();
  final AuthenticationService authService =
      GetIt.instance.get<AuthenticationService>();
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
    myItemsFilter = ItemFilter(ownerId: authService.currentUserId!);

    super.onInitialEvent(event, emit);
  }

  @override
  Future<void> onLoadItemsEvent(LoadMoreItemsEvent<ItemResponse> event,
      Emitter<MyItemListState> emit) async {
    // Load first page
    if (state.status == ListStateEnum.initial ||
        // First request failed and there is no next page link
        (state.status == ListStateEnum.error && event.nextPageLink.isEmpty)) {
      return loadItems(
          event, emit, () => itemService.getItems(filter: myItemsFilter));
    }

    // Load another page using next page link
    return loadItems(
        event, emit, () => itemService.getItemsByUri(event.nextPageLink));
  }

  void _onSearchTextUpdated(
      SearchTextUpdated event, Emitter<MyItemListState> emit) {
    // Update search text and status to refreshing
    emit(state.copyWith(
        search: event.searchText, status: ListStateEnum.initial));

    // Update filter
    myItemsFilter.search = event.searchText;
  }
}
