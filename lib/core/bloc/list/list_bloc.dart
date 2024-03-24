import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/responses/response_list.dart';
import 'package:stream_transform/stream_transform.dart';

part 'list_event.dart';
part 'list_state.dart';

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

abstract class ListBloc<TData, TState extends ListState<TData>>
    extends Bloc<ListEvent<TData>, TState> {
  String? nextPageLink;

  ListBloc(super.initState) {
    on<InitialEvent<TData>>(onInitialEvent);
    on<ReloadItemsEvent<TData>>(onReloadItemsEvent);
    on<LoadMoreEvent<TData>>(onLoadMoreEvent);
  }

  Future<void> onInitialEvent(
      InitialEvent<TData> event, Emitter<TState> emit) async {
    add(const ReloadItemsEvent());
  }

  Future<void> onReloadItemsEvent(
      ListEvent<TData> event, Emitter<TState> emit) async {
    throw UnimplementedError();
  }

  Future<void> reloadItems(ListEvent event, Emitter<TState> emit,
      Future<ResponseList<TData>> Function() fetcher) async {
    // Emit waiting state
    emit(state.copyWith(status: ListStateEnum.loading) as TState);

    try {
      // Load items
      var items = await fetcher.call();

      // Update next page link
      nextPageLink = items.nextPageLink;

      // Emit loaded state
      emit(state.copyWith(
        status: ListStateEnum.loaded,
        items: items.data,
        isLastPage: nextPageLink == null,
      ) as TState);
    } on Exception catch (e) {
      // Emit error state
      emit(state.copyWith(
        status: ListStateEnum.error,
        error: e,
      ) as TState);
    }
  }

  Future<void> onLoadMoreEvent(
      LoadMoreEvent<TData> event, Emitter<TState> emit) async {
    throw UnimplementedError();
  }

  Future<void> loadMore(ListEvent event, Emitter<TState> emit,
      Future<ResponseList<TData>> Function() fetcher) async {
    // If there is no next page, then return
    if (nextPageLink == null) {
      return;
    }

    // Do nothing if the state is not loaded
    if (state.status != ListStateEnum.loaded) {
      return;
    }

    try {
      // Load more items
      var listData = await fetcher.call();

      // Update next page link
      nextPageLink = listData.nextPageLink;

      // Emit loaded state with new items
      emit(state.copyWith(
        items: state.items..addAll(listData.data),
        // take all items from previous state and add new items
        isLastPage: nextPageLink == null,
      ) as TState);
    } on Exception catch (e) {
      // Do nothing if an exception was thrown because we are loaidng more items
    }
  }
}
