part of 'submit_bloc.dart';

@immutable
abstract class CreateLoanSubmitEvent {
  const CreateLoanSubmitEvent();
}

class CreateLoanSubmitInitialEvent extends CreateLoanSubmitEvent {
  const CreateLoanSubmitInitialEvent() : super();
}

class TryAgainEvent extends CreateLoanSubmitEvent {
  const TryAgainEvent();
}
