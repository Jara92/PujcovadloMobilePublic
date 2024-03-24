part of 'my_item_list_bloc.dart';

@immutable
abstract class MyItemListEvent {
  const MyItemListEvent();
}

class InitialEvent extends MyItemListEvent {
  const InitialEvent();
}

class SearchTextUpdated extends MyItemListEvent {
  final String searchText;

  const SearchTextUpdated({required this.searchText});
}

class LoadMoreEvent extends MyItemListEvent {
  const LoadMoreEvent();
}
