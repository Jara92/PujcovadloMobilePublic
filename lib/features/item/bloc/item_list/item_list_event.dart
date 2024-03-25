part of 'item_list_bloc.dart';

class SearchTextUpdated extends ListEvent<ItemResponse> {
  final String searchText;

  const SearchTextUpdated({required this.searchText});
}
