part of 'my_item_list_bloc.dart';

@immutable
class MyItemListState extends ListState<ItemResponse> {
  final String search;

  const MyItemListState({
    required super.status,
    required super.items,
    super.nextPageLink,
    super.error,
    this.search = "",
  });

  @override
  MyItemListState copyWith({
    ListStateEnum? status,
    List<ItemResponse>? items,
    String? nextPageLink,
    String? search,
    Exception? error,
  }) {
    return MyItemListState(
      status: status ?? this.status,
      items: items ?? this.items,
      nextPageLink: nextPageLink ?? this.nextPageLink,
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
        );
}

class ErrorState extends MyItemListState {
  const ErrorState({
    required super.error,
    super.status = ListStateEnum.error,
    super.items = const [],
  }) : super();
}

class LoadedState extends MyItemListState {
  const LoadedState({required super.items, required super.nextPageLink})
      : super(
          status: ListStateEnum.loaded,
        );
}
