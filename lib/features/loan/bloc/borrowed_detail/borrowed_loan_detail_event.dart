part of 'borrowed_loan_detail_bloc.dart';

@immutable
abstract class BorrowedLoanDetailEvent {}

class InitialEvent extends BorrowedLoanDetailEvent {}

class RefreshBorrowedLoanDetailEvent extends BorrowedLoanDetailEvent {}

class UpdateLoanStatusEvent extends BorrowedLoanDetailEvent {
  final LoanStatus status;

  UpdateLoanStatusEvent(this.status);
}

class ClearActionErrorEvent extends BorrowedLoanDetailEvent {}
