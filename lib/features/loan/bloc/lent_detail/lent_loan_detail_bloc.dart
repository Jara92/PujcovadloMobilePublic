import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/loan/enums/loan_status.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/services/loan_service.dart';

part 'lent_loan_detail_event.dart';
part 'lent_loan_detail_state.dart';

class LentLoanDetailBloc
    extends Bloc<LentLoanDetailEvent, LentLoanDetailState> {
  final LoanService _loanService = GetIt.instance.get<LoanService>();

  int? loanId;
  LoanResponse? loan;

  LentLoanDetailBloc({this.loanId, this.loan})
      : assert(loanId != null || loan != null),
        super(const LentLoanDetailInitial()) {
    on<InitialEvent>(_onInitialEvent);
    on<RefreshLentLoanDetailEvent>(_onRefreshLoanDetail);
    on<UpdateLoanStatusEvent>(_updateStatus);

    on<ClearActionErrorEvent>(_onClearActionError);
  }

  Future<void> _onInitialEvent(
      InitialEvent event, Emitter<LentLoanDetailState> emit) async {
    // Load the loan detail if it is not provided directly
    if (loan == null) {
      return _loadLoanDetail(emit);
    }

    // Set the loan id if it is not provided directly
    loanId = loan!.id;

    // Emit loaded state if the loan is provided directly
    emit(LentLoanDetailLoaded(loan: loan!));
  }

  Future<void> _loadLoanDetail(Emitter<LentLoanDetailState> emit) async {
    // Emit loading state
    emit(const LentLoanDetailLoading());

    try {
      // Loan loan by id
      loan = await _loanService.getLoanById(loanId!);

      // Emit loaded state
      emit(LentLoanDetailLoaded(loan: loan!));
    }
    // Emit failed state if an exception was thrown
    on Exception catch (e) {
      emit(LentLoanDetailFailed(error: e));
    }
  }

  Future<void> _updateStatus(
      UpdateLoanStatusEvent event, Emitter<LentLoanDetailState> emit) async {
    // Emit loading state
    emit(state.copyWith(
      isBusy: true,
    ));

    try {
      // Try to update the loan status
      await _loanService.updateLoanStatus(loan!.id, event.status);
      loan!.status = event.status;

      emit(state.copyWith(
        isBusy: false,
      ));
    } on Exception catch (e) {
      // Emit action failed status
      emit(state.copyWith(
        isBusy: false,
        actionError: () => e,
      ));
    }
  }

  Future<void> _onClearActionError(
      ClearActionErrorEvent event, Emitter<LentLoanDetailState> emit) async {
    // Clear the action error
    emit(state.copyWith(
      actionError: () => null,
    ));
  }

  Future<void> _onRefreshLoanDetail(RefreshLentLoanDetailEvent event,
      Emitter<LentLoanDetailState> emit) async {
    // Refresh the page by loading the loan again
    return _loadLoanDetail(emit);
  }
}
