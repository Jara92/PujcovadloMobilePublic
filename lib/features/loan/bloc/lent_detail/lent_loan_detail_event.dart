part of 'lent_loan_detail_bloc.dart';

@immutable
abstract class LentLoanDetailEvent {}

class LoadLentLoanDetail extends LentLoanDetailEvent {}

class RefreshLentLoanDetailEvent extends LentLoanDetailEvent {}
