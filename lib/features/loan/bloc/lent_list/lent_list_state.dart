part of 'lent_list_bloc.dart';

@immutable
class LentListState extends ListState<LoanResponse> {
  final String search;

  const LentListState({
    required super.status,
    required super.items,
    super.nextPageLink,
    super.error,
    this.search = "",
  });

  @override
  LentListState copyWith({
    ListStateEnum? status,
    List<LoanResponse>? items,
    String? nextPageLink,
    String? search,
    Exception? error,
  }) {
    return LentListState(
      status: status ?? this.status,
      items: items ?? this.items,
      nextPageLink: nextPageLink ?? this.nextPageLink,
      search: search ?? this.search,
      error: error ?? this.error,
    );
  }
}

class InitialState extends LentListState {
  const InitialState()
      : super(
          status: ListStateEnum.initial,
          items: const [],
        );
}

class ErrorState extends LentListState {
  const ErrorState({
    required super.error,
    super.status = ListStateEnum.error,
    super.items = const [],
  }) : super();
}

class LoadedState extends LentListState {
  const LoadedState({required super.items, required super.nextPageLink})
      : super(
          status: ListStateEnum.loaded,
        );
}
