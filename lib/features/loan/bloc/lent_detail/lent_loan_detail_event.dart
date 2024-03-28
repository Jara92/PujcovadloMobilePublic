part of 'lent_loan_detail_bloc.dart';

@immutable
abstract class LentLoanDetailEvent {}

class InitialEvent extends LentLoanDetailEvent {}

class RefreshLentLoanDetailEvent extends LentLoanDetailEvent {}

class UpdateLoanStatusEvent extends LentLoanDetailEvent {
  final LoanStatus status;

  UpdateLoanStatusEvent(this.status);
}

class ClearActionErrorEvent extends LentLoanDetailEvent {}
