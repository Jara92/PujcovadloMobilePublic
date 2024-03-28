part of 'borrowed_loan_detail_bloc.dart';

enum BorrowedLoanDetailStateEnum { initial, loading, loaded, error }

@immutable
class BorrowedLoanDetailState {
  final BorrowedLoanDetailStateEnum status;
  final LoanResponse? loan;
  final Exception? error;
  final bool isBusy;
  final Exception? actionError;

  const BorrowedLoanDetailState({
    required this.status,
    this.loan,
    this.error,
    this.isBusy = false,
    this.actionError,
  });

  BorrowedLoanDetailState copyWith({
    BorrowedLoanDetailStateEnum? status,
    LoanResponse? loan,
    Exception? Function()? error,
    bool? isBusy,
    Exception? Function()? actionError,
  }) {
    return BorrowedLoanDetailState(
      status: status ?? this.status,
      loan: loan ?? this.loan,
      error: error != null ? error() : this.error,
      isBusy: isBusy ?? this.isBusy,
      actionError: actionError != null ? actionError() : this.actionError,
    );
  }
}

class BorrowedLoanDetailInitial extends BorrowedLoanDetailState {
  const BorrowedLoanDetailInitial()
      : super(status: BorrowedLoanDetailStateEnum.initial);
}

class BorrowedLoanDetailLoading extends BorrowedLoanDetailState {
  const BorrowedLoanDetailLoading()
      : super(status: BorrowedLoanDetailStateEnum.loading);
}

class BorrowedLoanDetailLoaded extends BorrowedLoanDetailState {
  const BorrowedLoanDetailLoaded({required super.loan})
      : super(status: BorrowedLoanDetailStateEnum.loaded);
}

class BorrowedLoanDetailFailed extends BorrowedLoanDetailState {
  const BorrowedLoanDetailFailed({required super.error})
      : super(status: BorrowedLoanDetailStateEnum.error);
}
