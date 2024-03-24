part of 'my_item_list_bloc.dart';

enum MyItemListStateEnum { initial, loading, loaded, error }

@immutable
class MyItemListState {
  final MyItemListStateEnum status;
  final List<ItemResponse> items;
  final bool isLastPage;
  final Exception? error;
  final String search;

  const MyItemListState({
    required this.status,
    required this.items,
    required this.isLastPage,
    this.search = "",
    this.error,
  });

  MyItemListState copyWith({
    MyItemListStateEnum? status,
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
          status: MyItemListStateEnum.initial,
          items: const [],
          isLastPage: false,
        );
}

class ErrorState extends MyItemListState {
  const ErrorState({
    required super.error,
    super.status = MyItemListStateEnum.error,
    super.isLastPage = false,
    super.items = const [],
  }) : super();
}

class LoadingState extends MyItemListState {
  const LoadingState()
      : super(
          status: MyItemListStateEnum.loading,
          items: const [],
          isLastPage: false,
        );
}

class LoadedState extends MyItemListState {
  const LoadedState({required super.items, required super.isLastPage})
      : super(
          status: MyItemListStateEnum.loaded,
        );
}
