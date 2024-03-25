part of 'item_list_bloc.dart';

@immutable
class ItemListState extends ListState<ItemResponse> {
  final String search;

  const ItemListState({
    required super.status,
    required super.items,
    super.nextPageLink,
    super.error,
    this.search = "",
  });

  @override
  ItemListState copyWith({
    ListStateEnum? status,
    List<ItemResponse>? items,
    String? nextPageLink,
    String? search,
    Exception? error,
  }) {
    return ItemListState(
      status: status ?? this.status,
      items: items ?? this.items,
      nextPageLink: nextPageLink ?? this.nextPageLink,
      search: search ?? this.search,
      error: error ?? this.error,
    );
  }
}

class InitialState extends ItemListState {
  const InitialState()
      : super(
          status: ListStateEnum.initial,
          items: const [],
        );
}

class ErrorState extends ItemListState {
  const ErrorState({
    required super.error,
    super.status = ListStateEnum.error,
    super.items = const [],
  }) : super();
}

class LoadedState extends ItemListState {
  const LoadedState({required super.items, required super.nextPageLink})
      : super(
          status: ListStateEnum.loaded,
        );
}
