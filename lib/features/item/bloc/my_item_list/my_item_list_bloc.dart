import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/item/filters/item_filter.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';

part 'my_item_list_event.dart';
part 'my_item_list_state.dart';

class MyItemListBloc extends Bloc<MyItemListEvent, MyItemListState> {
  final ItemService itemService = GetIt.instance.get<ItemService>();
  late final ItemFilter myItemsFilter;
  String? nextPageLink;

  MyItemListBloc() : super(const InitialState()) {
    on<InitialEvent>(_onInitialEvent);
    on<SearchTextUpdated>(_onSearchTextUpdated);
    on<LoadMoreEvent>(_onLoadMoreEvent);
  }

  Future<void> _onInitialEvent(
      InitialEvent event, Emitter<MyItemListState> emit) async {
    // todo: get real user id
    myItemsFilter = ItemFilter(ownerId: "13f11f92-6c4d-44e2-b7a8-3609d80a439c");

    // Init state using empty filter
    add(const SearchTextUpdated(searchText: ""));
  }

  Future<void> _onSearchTextUpdated(
      SearchTextUpdated event, Emitter<MyItemListState> emit) {
    myItemsFilter.search = event.searchText;

    return _onFiltersUpdated(emit);
  }

  Future<void> _onFiltersUpdated(Emitter<MyItemListState> emit) async {
    // Emit loading state
    emit(const LoadingState());

    try {
      // Load items
      var items = await itemService.getItems(filter: myItemsFilter);

      // Update next page link
      nextPageLink = items.nextPageLink;

      // Emit loaded state
      emit(LoadedState(
        items: items.data,
        isLastPage: nextPageLink == null,
      ));
    } on Exception catch (e) {
      // Emit error state
      emit(ErrorState(error: e));
    }
  }

  Future<void> _onLoadMoreEvent(
      LoadMoreEvent event, Emitter<MyItemListState> emit) async {
    // If there is no next page, then return
    if (nextPageLink == null) {
      return;
    }

    // Do nothing if the state is not loaded
    if (state.status != MyItemListStateEnum.loaded) {
      return;
    }

    try {
      // Load more items
      var items = await itemService.getItemsByUri(nextPageLink!);

      // Update next page link
      nextPageLink = items.nextPageLink;

      // Emit loaded state with new items
      emit(state.copyWith(
        items: state.items..addAll(items.data),
        // take all items from previous state and add new items
        isLastPage: nextPageLink == null,
      ));
    } on Exception catch (e) {
      // Do nothing if an exception was thrown because we are loaidng more items
    }
  }
}
