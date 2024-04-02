part of 'lent_loan_detail_bloc.dart';

@immutable
abstract class LentLoanDetailEvent {
  const LentLoanDetailEvent();
}

class InitialEvent extends LentLoanDetailEvent {
  const InitialEvent();
}

class RefreshLentLoanDetailEvent extends LentLoanDetailEvent {}

/// Event to rebuild the loan detail. It doesnt fetch the loan detail again but just rebuilds the UI.
class RebuildLoanDetailEvent extends LentLoanDetailEvent {
  const RebuildLoanDetailEvent();
}

class UpdateLoanStatusEvent extends LentLoanDetailEvent {
  final LoanStatus status;

  const UpdateLoanStatusEvent(this.status);
}

class ClearActionErrorEvent extends LentLoanDetailEvent {}
