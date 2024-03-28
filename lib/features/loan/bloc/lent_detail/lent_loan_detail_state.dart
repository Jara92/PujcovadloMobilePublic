part of 'lent_loan_detail_bloc.dart';

enum LentLoanDetailStateEnum { initial, loading, loaded, error }

@immutable
class LentLoanDetailState {
  final LentLoanDetailStateEnum status;
  final LoanResponse? loan;
  final Exception? error;
  final bool isBusy;
  final Exception? actionError;

  const LentLoanDetailState({
    required this.status,
    this.loan,
    this.error,
    this.isBusy = false,
    this.actionError,
  });

  LentLoanDetailState copyWith({
    LentLoanDetailStateEnum? status,
    LoanResponse? loan,
    Exception? Function()? error,
    bool? isBusy,
    Exception? Function()? actionError,
  }) {
    return LentLoanDetailState(
      status: status ?? this.status,
      loan: loan ?? this.loan,
      error: error != null ? error() : this.error,
      isBusy: isBusy ?? this.isBusy,
      actionError: actionError != null ? actionError() : this.actionError,
    );
  }
}

class LentLoanDetailInitial extends LentLoanDetailState {
  const LentLoanDetailInitial()
      : super(status: LentLoanDetailStateEnum.initial);
}

class LentLoanDetailLoading extends LentLoanDetailState {
  const LentLoanDetailLoading()
      : super(status: LentLoanDetailStateEnum.loading);
}

class LentLoanDetailLoaded extends LentLoanDetailState {
  const LentLoanDetailLoaded({required super.loan})
      : super(status: LentLoanDetailStateEnum.loaded);
}

class LentLoanDetailFailed extends LentLoanDetailState {
  const LentLoanDetailFailed({required super.error})
      : super(status: LentLoanDetailStateEnum.error);
}
