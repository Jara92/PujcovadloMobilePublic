part of 'create_loan_bloc.dart';

@immutable
abstract class CreateLoanFormEvent {
  const CreateLoanFormEvent();
}

class InitialEvent extends CreateLoanFormEvent {
  const InitialEvent();
}

class RefreshCreateLoanFormEvent extends CreateLoanFormEvent {
  const RefreshCreateLoanFormEvent();
}

class UpdatedDatesEvent extends CreateLoanFormEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const UpdatedDatesEvent({this.startDate, this.endDate});
}

class TenantNoteChangedEvent extends CreateLoanFormEvent {
  final String note;

  const TenantNoteChangedEvent({required this.note});
}

class SubmitCreateLoanFormEvent extends CreateLoanFormEvent {
  const SubmitCreateLoanFormEvent();
}
