part of 'lent_list_bloc.dart';

class SearchTextUpdated extends ListEvent<LoanResponse> {
  final String searchText;

  const SearchTextUpdated({required this.searchText});
}
