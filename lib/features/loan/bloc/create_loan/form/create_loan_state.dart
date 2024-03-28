part of 'create_loan_bloc.dart';

enum CreateLoanFormStateEnum { initial, loading, loaded, error, submited }

@immutable
class CreateLoanFormState {
  final CreateLoanFormStateEnum status;
  final ItemResponse? item;
  final Exception? error;

  final LoanDates dates;
  final LoanTenantNote tenantNote;

  final LoanRequest? loanRequest;

  /// Get the number of days between the start and end dates (minimum  when start=end)
  int? get days => (dates.value?.diffInDays != null)
      ? max(1, dates.value!.diffInDays!)
      : null;

  /// Get the expected price of the loan
  double? get expectedPrice =>
      (days != null && item != null) ? days! * item!.pricePerDay : null;

  /// Is the form valid?
  bool get isValid => dates.isValid && tenantNote.isValid;

  const CreateLoanFormState({
    required this.status,
    this.item,
    this.error,
    this.dates = const LoanDates.pure(),
    this.tenantNote = const LoanTenantNote.pure(),
    this.loanRequest,
  });

  CreateLoanFormState copyWith({
    CreateLoanFormStateEnum? status,
    ItemResponse? item,
    Exception? Function()? error,
    LoanDates? dates,
    LoanTenantNote? tenantNote,
    LoanRequest? loanRequest,
  }) {
    return CreateLoanFormState(
      status: status ?? this.status,
      item: item ?? this.item,
      error: error != null ? error() : this.error,
      dates: dates ?? this.dates,
      tenantNote: tenantNote ?? this.tenantNote,
      loanRequest: loanRequest ?? this.loanRequest,
    );
  }
}

class CreateLoanFormInitial extends CreateLoanFormState {
  const CreateLoanFormInitial()
      : super(status: CreateLoanFormStateEnum.initial);
}

class CreateLoanFormLoading extends CreateLoanFormState {
  const CreateLoanFormLoading()
      : super(status: CreateLoanFormStateEnum.loading);
}

class CreateLoanFormLoaded extends CreateLoanFormState {
  const CreateLoanFormLoaded({required super.item})
      : super(status: CreateLoanFormStateEnum.loaded);
}

class CreateLoanFormFailed extends CreateLoanFormState {
  const CreateLoanFormFailed({required super.error})
      : super(status: CreateLoanFormStateEnum.error);
}
