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
  ListBloc(super.initState) {
    on<InitialEvent<TData>>(onInitialEvent);
    on<LoadMoreItemsEvent<TData>>(onLoadItemsEvent);
  }

  Future<void> onInitialEvent(
      InitialEvent<TData> event, Emitter<TState> emit) async {}

  Future<void> onLoadItemsEvent(LoadMoreItemsEvent<TData> event,
      Emitter<TState> emit) async {
    throw UnimplementedError();
  }

  Future<void> loadItems(LoadMoreItemsEvent<TData> event, Emitter<TState> emit,
      Future<ResponseList<TData>> Function() fetcher) async {
    try {
      // Load more items
      var listData = await fetcher.call();

      // Emit loaded state with new items
      emit(state.copyWith(
        status: ListStateEnum.loaded, // Set status to loaded
        items: listData.data, // Add new items to the list
        nextPageLink: listData.nextPageLink ??
            '', // If null set next page link to empty string
      ) as TState);
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ListStateEnum.error, // error state
          error: e, // pass error
          items: const [], // no new items
          nextPageLink: event.nextPageLink, // Set the same next page link
        ) as TState,
      );
    }
  }
}
