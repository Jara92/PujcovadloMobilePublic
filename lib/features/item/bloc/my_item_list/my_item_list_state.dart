part of 'my_item_list_bloc.dart';

@immutable
class MyItemListState extends ListState<ItemResponse> {
  final String search;

  const MyItemListState({
    required super.status,
    required super.items,
    required super.isLastPage,
    super.error,
    this.search = "",
  });

  @override
  MyItemListState copyWith({
    ListStateEnum? status,
    List<ItemResponse>? items,
    bool? isLastPage,
    String? search,
    Exception? error,
  }) {
    return MyItemListState(
      status: status ?? this.status,
      items: items ?? this.items,
      isLastPage: isLastPage ?? this.isLastPage,
      search: search ?? this.search,
      error: error ?? this.error,
    );
  }
}

class InitialState extends MyItemListState {
  const InitialState()
      : super(
          status: ListStateEnum.initial,
          items: const [],
          isLastPage: false,
        );
}

class ErrorState extends MyItemListState {
  const ErrorState({
    required super.error,
    super.status = ListStateEnum.error,
    super.isLastPage = false,
    super.items = const [],
  }) : super();
}

class LoadingState extends MyItemListState {
  const LoadingState()
      : super(
          status: ListStateEnum.loading,
          items: const [],
          isLastPage: false,
        );
}

class LoadedState extends MyItemListState {
  const LoadedState({required super.items, required super.isLastPage})
      : super(
          status: ListStateEnum.loaded,
        );
}
