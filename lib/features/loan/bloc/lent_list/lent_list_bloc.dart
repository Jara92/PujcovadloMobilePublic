import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';
import 'package:pujcovadlo_client/features/authentication/services/authentication_service.dart';
import 'package:pujcovadlo_client/features/loan/filters/loan_filter.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/services/loan_service.dart';

export 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';

part 'lent_list_event.dart';
part 'lent_list_state.dart';

class LentListBloc extends ListBloc<LoanResponse, LentListState> {
  final LoanService _loanService = GetIt.instance.get<LoanService>();
  final AuthenticationService _authService =
      GetIt.instance.get<AuthenticationService>();
  late final LoanFilter loanFilter;

  LentListBloc() : super(const InitialState()) {
    on<SearchTextUpdated>(
      _onSearchTextUpdated,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  @override
  Future<void> onInitialEvent(
      InitialEvent<LoanResponse> event, Emitter<LentListState> emit) async {
    loanFilter = LoanFilter(ownerId: _authService.currentUserId!);

    super.onInitialEvent(event, emit);
  }

  @override
  Future<void> onLoadItemsEvent(
      LoaditemsEvent<LoanResponse> event, Emitter<LentListState> emit) async {
    // If initial status or no next page link, load items from the beginning
    if (state.status == ListStateEnum.initial || event.nextPageLink.isEmpty) {
      return loadItems(
          event, emit, () => _loanService.getLoans(filter: loanFilter));
    }

    // Load another page using next page link
    return loadItems(
        event, emit, () => _loanService.getLoansByUri(event.nextPageLink));
  }

  void _onSearchTextUpdated(
      SearchTextUpdated event, Emitter<LentListState> emit) {
    // Update search text and status to refreshing
    emit(state.copyWith(
        search: event.searchText, status: ListStateEnum.initial));

    // Update filter
    loanFilter.search = event.searchText;
  }
}
