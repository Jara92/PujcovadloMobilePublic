part of 'item_list_bloc.dart';

@immutable
abstract class ItemListEvent {
  const ItemListEvent();
}

class SearchTextUpdated extends ItemListEvent {
  final String searchText;

  const SearchTextUpdated({required this.searchText});
}
