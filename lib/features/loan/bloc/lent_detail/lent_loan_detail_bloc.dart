import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/services/loan_service.dart';

part 'lent_loan_detail_event.dart';
part 'lent_loan_detail_state.dart';

class LentLoanDetailBloc
    extends Bloc<LentLoanDetailEvent, LentLoanDetailState> {
  final LoanService _loanService = GetIt.instance.get<LoanService>();

  final int? loanId;
  LoanResponse? loan;

  LentLoanDetailBloc({this.loanId, this.loan})
      : assert(loanId != null || loan != null),
        super(const LentLoanDetailInitial()) {
    on<LoadLentLoanDetail>(_onLoadLentLoanDetail);
    on<RefreshLentLoanDetailEvent>(_onRefreshLoanDetail);
  }

  Future<void> _onLoadLentLoanDetail(
      LoadLentLoanDetail event, Emitter<LentLoanDetailState> emit) async {
    // Emit loading state
    emit(const LentLoanDetailLoading());

    try {
      // Load profily by id if profile is not provided directly
      loan ??= await _loanService.getLoanById(loanId!);

      // Emit loaded state
      emit(LentLoanDetailLoaded(loan: loan!));
    }
    // Emit failed state if an exception was thrown
    on Exception catch (e) {
      emit(LentLoanDetailFailed(error: e));
    }
  }

  Future<void> _onRefreshLoanDetail(RefreshLentLoanDetailEvent event,
      Emitter<LentLoanDetailState> emit) async {
    throw UnimplementedError();
  }
}
