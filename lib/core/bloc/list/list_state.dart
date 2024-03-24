part of 'list_bloc.dart';

enum ListStateEnum { initial, loading, loaded, refreshing, error }

@immutable
class ListState<T> {
  final ListStateEnum status;
  final List<T> items;
  final bool isLastPage;
  final Exception? error;

  const ListState({
    required this.status,
    required this.items,
    required this.isLastPage,
    this.error,
  });

  ListState<T> copyWith({
    ListStateEnum? status,
    List<T>? items,
    bool? isLastPage,
    String? search,
    Exception? error,
  }) {
    return ListState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      isLastPage: isLastPage ?? this.isLastPage,
      error: error ?? this.error,
    );
  }
}
