part of 'lent_loan_detail_bloc.dart';

@immutable
abstract class LentLoanDetailState {
  final bool isLoading;

  const LentLoanDetailState({required this.isLoading});
}

class LentLoanDetailInitial extends LentLoanDetailState {
  const LentLoanDetailInitial({super.isLoading = false});
}

class LentLoanDetailLoading extends LentLoanDetailState {
  const LentLoanDetailLoading({super.isLoading = true});
}

class LentLoanDetailLoaded extends LentLoanDetailState {
  final LoanResponse loan;

  const LentLoanDetailLoaded({required this.loan, super.isLoading = false});
}

class LentLoanDetailNotFound extends LentLoanDetailState {
  const LentLoanDetailNotFound({super.isLoading = false});
}

class LentLoanDetailFailed extends LentLoanDetailState {
  final Exception error;

  const LentLoanDetailFailed({required this.error, super.isLoading = false});
}
