part of 'borrowed_list_bloc.dart';

@immutable
class BorrowedListState extends ListState<LoanResponse> {
  final String search;

  const BorrowedListState({
    required super.status,
    required super.items,
    super.nextPageLink,
    super.error,
    this.search = "",
  });

  @override
  BorrowedListState copyWith({
    ListStateEnum? status,
    List<LoanResponse>? items,
    String? nextPageLink,
    String? search,
    Exception? error,
  }) {
    return BorrowedListState(
      status: status ?? this.status,
      items: items ?? this.items,
      nextPageLink: nextPageLink ?? this.nextPageLink,
      search: search ?? this.search,
      error: error ?? this.error,
    );
  }
}

class InitialState extends BorrowedListState {
  const InitialState()
      : super(
          status: ListStateEnum.initial,
          items: const [],
        );
}

class ErrorState extends BorrowedListState {
  const ErrorState({
    required super.error,
    super.status = ListStateEnum.error,
    super.items = const [],
  }) : super();
}

class LoadedState extends BorrowedListState {
  const LoadedState({required super.items, required super.nextPageLink})
      : super(
          status: ListStateEnum.loaded,
        );
}
