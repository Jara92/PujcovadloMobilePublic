part of 'borrowed_loan_detail_bloc.dart';

@immutable
abstract class BorrowedLoanDetailEvent {
  const BorrowedLoanDetailEvent();
}

class InitialEvent extends BorrowedLoanDetailEvent {
  const InitialEvent();
}

class RefreshBorrowedLoanDetailEvent extends BorrowedLoanDetailEvent {}

/// Event to rebuild the loan detail. It doesnt fetch the loan detail again but just rebuilds the UI.
class RebuildLoanDetailEvent extends BorrowedLoanDetailEvent {
  const RebuildLoanDetailEvent();
}

class UpdateLoanStatusEvent extends BorrowedLoanDetailEvent {
  final LoanStatus status;

  const UpdateLoanStatusEvent(this.status);
}

class ClearActionErrorEvent extends BorrowedLoanDetailEvent {}
