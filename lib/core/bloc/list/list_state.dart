part of 'list_bloc.dart';

enum ListStateEnum { initial, loaded, error }

@immutable
class ListState<T> {
  final ListStateEnum status;
  final List<T> items;
  final String nextPageLink;

  bool get isLastPage => nextPageLink.isEmpty;
  final Exception? error;

  const ListState({
    required this.status,
    required this.items,
    this.nextPageLink = "",
    this.error,
  });

  ListState<T> copyWith({
    ListStateEnum? status,
    List<T>? items,
    String? nextPageLink,
    Exception? error,
  }) {
    return ListState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      nextPageLink: nextPageLink ?? this.nextPageLink,
      error: error ?? this.error,
    );
  }
}
