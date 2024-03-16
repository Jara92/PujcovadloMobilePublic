part of 'my_item_list_bloc.dart';

@immutable
abstract class ItemListEvent {
  const ItemListEvent();
}

class InitialEvent extends ItemListEvent {
  const InitialEvent();
}

class SearchTextUpdated extends ItemListEvent {
  final String searchText;

  const SearchTextUpdated({required this.searchText});
}
