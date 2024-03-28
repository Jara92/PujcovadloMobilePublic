part of 'submit_bloc.dart';

enum CreateLoanSubmitEventEnum { initial, processing, error, success }

@immutable
class CreateLoanSubmitState {
  final CreateLoanSubmitEventEnum status;
  final Exception? error;

  // bool get isDataSet => data != null;

  const CreateLoanSubmitState({
    required this.status,
    this.error,
  });

  CreateLoanSubmitState copyWith({
    CreateLoanSubmitEventEnum? status,
    Exception? Function()? error,
  }) {
    return CreateLoanSubmitState(
      status: status ?? this.status,
      error: error != null ? error() : this.error,
    );
  }
}

class InitialState extends CreateLoanSubmitState {
  const InitialState() : super(status: CreateLoanSubmitEventEnum.initial);
}

class ProcessingState extends CreateLoanSubmitState {
  const ProcessingState() : super(status: CreateLoanSubmitEventEnum.processing);
}

class ErrorState extends CreateLoanSubmitState {
  const ErrorState({
    required super.error,
  }) : super(status: CreateLoanSubmitEventEnum.error);
}

class SuccessState extends CreateLoanSubmitState {
  final LoanResponse? loan;
  final int? loanId;

  const SuccessState({this.loan, this.loanId})
      // Loan or its id must not be null
      : assert(loan != null || loanId != null),
        super(status: CreateLoanSubmitEventEnum.success);
}
