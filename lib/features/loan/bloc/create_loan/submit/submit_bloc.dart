import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/loan/requests/loan_request.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/services/loan_service.dart';
import 'package:stream_transform/stream_transform.dart';

part 'submit_event.dart';
part 'submit_state.dart';

class CreateLoanSubmitBloc
    extends Bloc<CreateLoanSubmitEvent, CreateLoanSubmitState> {
  final LoanService _loanService = GetIt.instance.get<LoanService>();
  late final LoanRequest loan;

  CreateLoanSubmitBloc(this.loan) : super(const InitialState()) {
    on<CreateLoanSubmitInitialEvent>(_onInitialEvent);
    on<TryAgainEvent>(_onTryAgain,
        transformer:
            // Prevent multiple requests
            (events, mapper) => events
                .debounce(const Duration(milliseconds: 100))
                .switchMap(mapper));
  }

  Future<void> _onInitialEvent(CreateLoanSubmitInitialEvent event,
      Emitter<CreateLoanSubmitState> emit) async {
    // try to save the item
    await _saveLoan(event, emit);
  }

  Future<void> _onTryAgain(
      TryAgainEvent event, Emitter<CreateLoanSubmitState> emit) async {
    // try to save the item
    await _saveLoan(event, emit);
  }

  Future<void> _saveLoan(
      CreateLoanSubmitEvent event, Emitter<CreateLoanSubmitState> emit) async {
    // Prevent multiple requests
    if (state.status == CreateLoanSubmitEventEnum.processing) return;

    emit(const ProcessingState());

    try {
      // Create new loan
      var newLoan = await _loanService.createLoan(loan);

      // Emit success state and pass item id
      emit(SuccessState(loanId: newLoan.id, loan: newLoan));
    } on Exception catch (e) {
      print(e);
      emit(ErrorState(error: e));
    }
  }
}
