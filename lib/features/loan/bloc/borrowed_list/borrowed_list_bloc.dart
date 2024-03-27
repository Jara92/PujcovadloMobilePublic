import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';
import 'package:pujcovadlo_client/features/loan/filters/loan_filter.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/services/loan_service.dart';

export 'package:pujcovadlo_client/core/bloc/list/list_bloc.dart';

part 'borrowed_list_event.dart';
part 'borrowed_list_state.dart';

class BorrowedListBloc extends ListBloc<LoanResponse, BorrowedListState> {
  final LoanService _loanService = GetIt.instance.get<LoanService>();
  late final LoanFilter loanFilter;

  BorrowedListBloc() : super(const InitialState()) {
    on<SearchTextUpdated>(
      _onSearchTextUpdated,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  @override
  Future<void> onInitialEvent(
      InitialEvent<LoanResponse> event, Emitter<BorrowedListState> emit) async {
    // todo: get real user id
    loanFilter = LoanFilter(tenantId: "13f11f92-6c4d-44e2-b7a8-3609d80a439c");

    super.onInitialEvent(event, emit);
  }

  @override
  Future<void> onLoadItemsEvent(LoaditemsEvent<LoanResponse> event,
      Emitter<BorrowedListState> emit) async {
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
      SearchTextUpdated event, Emitter<BorrowedListState> emit) {
    // Update search text and status to refreshing
    emit(state.copyWith(
        search: event.searchText, status: ListStateEnum.initial));

    // Update filter
    loanFilter.search = event.searchText;
  }
}
