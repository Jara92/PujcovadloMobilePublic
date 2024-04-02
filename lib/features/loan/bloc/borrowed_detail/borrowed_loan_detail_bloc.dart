import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/authentication/services/authentication_service.dart';
import 'package:pujcovadlo_client/features/loan/enums/loan_status.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/services/loan_service.dart';

part 'borrowed_loan_detail_event.dart';
part 'borrowed_loan_detail_state.dart';

class BorrowedLoanDetailBloc
    extends Bloc<BorrowedLoanDetailEvent, BorrowedLoanDetailState> {
  final LoanService _loanService = GetIt.instance.get<LoanService>();
  final AuthenticationService _authenticationService =
      GetIt.instance.get<AuthenticationService>();

  int? loanId;
  LoanResponse? loan;

  BorrowedLoanDetailBloc({this.loanId, this.loan})
      : assert(loanId != null || loan != null),
        super(const BorrowedLoanDetailInitial()) {
    on<InitialEvent>(_onInitialEvent);
    on<RefreshBorrowedLoanDetailEvent>(_onRefreshLoanDetail);
    on<RebuildLoanDetailEvent>(_onRebuildLoanDetailEvent);
    on<UpdateLoanStatusEvent>(_updateStatus);

    on<ClearActionErrorEvent>(_onClearActionError);
  }

  Future<void> _onInitialEvent(
      InitialEvent event, Emitter<BorrowedLoanDetailState> emit) async {
    // Load the loan detail if it is not provided directly
    if (loan == null) {
      return _loadLoanDetail(emit);
    }

    // Set the loan id if it is not provided directly
    loanId = loan!.id;

    // Emit loaded state if the loan is provided directly
    emit(BorrowedLoanDetailLoaded(loan: loan!));
  }

  Future<void> _loadLoanDetail(Emitter<BorrowedLoanDetailState> emit) async {
    // Emit loading state
    emit(const BorrowedLoanDetailLoading());

    try {
      // Loan loan by id
      loan = await _loanService.getLoanById(loanId!);

      // Emit loaded state
      emit(BorrowedLoanDetailLoaded(loan: loan!));
    }
    // Emit failed state if an exception was thrown
    on Exception catch (e) {
      emit(BorrowedLoanDetailFailed(error: e));
    }
  }

  Future<void> _updateStatus(UpdateLoanStatusEvent event,
      Emitter<BorrowedLoanDetailState> emit) async {
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

  Future<void> _onClearActionError(ClearActionErrorEvent event,
      Emitter<BorrowedLoanDetailState> emit) async {
    // Clear the action error
    emit(state.copyWith(
      actionError: () => null,
    ));
  }

  Future<void> _onRefreshLoanDetail(RefreshBorrowedLoanDetailEvent event,
      Emitter<BorrowedLoanDetailState> emit) async {
    // Refresh the page by loading the loan again
    return _loadLoanDetail(emit);
  }

  void _onRebuildLoanDetailEvent(RebuildLoanDetailEvent event,
      Emitter<BorrowedLoanDetailState> emit) async {
    // Emit loaded state
    emit(state.copyWith());
  }

  bool canReview(LoanResponse loan) {
    final currentUserId = _authenticationService.currentUserId!;

    // Return true if there is no review from the current user
    return loan.reviews
        .where((element) => element.authorId == currentUserId)
        .isEmpty;
  }
}
