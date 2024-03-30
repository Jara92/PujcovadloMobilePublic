import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/core/objects/datetime_range.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';
import 'package:pujcovadlo_client/features/loan/models/loan_dates.dart';
import 'package:pujcovadlo_client/features/loan/models/loan_tenant_note.dart';
import 'package:pujcovadlo_client/features/loan/requests/loan_request.dart';
import 'package:pujcovadlo_client/features/loan/services/loan_service.dart';

part 'create_loan_event.dart';
part 'create_loan_state.dart';

class CreateLoanFormBloc
    extends Bloc<CreateLoanFormEvent, CreateLoanFormState> {
  final LoanService _loanService = GetIt.instance.get<LoanService>();
  final ItemService _itemService = GetIt.instance.get<ItemService>();

  int? itemId;
  ItemResponse? item;

  CreateLoanFormBloc({this.itemId, this.item})
      : assert(itemId != null || item != null),
        super(const CreateLoanFormInitial()) {
    on<InitialEvent>(_onInitialEvent);
    on<RefreshCreateLoanFormEvent>(_onRefreshLoanDetail);
    on<UpdatedDatesEvent>(_onUpdateDates);
    on<TenantNoteChangedEvent>(_onTenantNoteChanged);
  }

  Future<void> _onInitialEvent(
      InitialEvent event, Emitter<CreateLoanFormState> emit) async {
    // Load the loan detail if it is not provided directly
    if (item == null) {
      return _loadLoanDetail(emit);
    }

    // Set the loan id if it is not provided directly
    itemId = item!.id;

    // Emit loaded state if the loan is provided directly
    emit(CreateLoanFormLoaded(item: item!));
  }

  Future<void> _loadLoanDetail(Emitter<CreateLoanFormState> emit) async {
    // Emit loading state
    emit(const CreateLoanFormLoading());

    try {
      // Loan loan by id
      item = await _itemService.getItemById(itemId!);

      // Emit loaded state
      emit(CreateLoanFormLoaded(item: item!));
    }
    // Emit failed state if an exception was thrown
    on Exception catch (e) {
      emit(CreateLoanFormFailed(error: e));
    }
  }

  Future<void> _onRefreshLoanDetail(RefreshCreateLoanFormEvent event,
      Emitter<CreateLoanFormState> emit) async {
    // Refresh the page by loading the loan again
    return _loadLoanDetail(emit);
  }

  Future<void> _onUpdateDates(
      UpdatedDatesEvent event, Emitter<CreateLoanFormState> emit) async {
    // Validate new dates
    final newDates = LoanDates.dirty(DateTimeRange(
      start: event.startDate,
      end: event.endDate,
    ));

    // Update bloc state
    emit(state.copyWith(
      dates: newDates,
    ));
  }

  Future<void> _onTenantNoteChanged(
      TenantNoteChangedEvent event, Emitter<CreateLoanFormState> emit) async {
    // Update tenant note
    final newNote = LoanTenantNote.dirty(event.note);

    // Update bloc state
    emit(state.copyWith(
      tenantNote: newNote,
    ));
  }

  LoanRequest get request {
    return LoanRequest(
      itemId: item!.id,
      from: state.dates.value!.start,
      to: state.dates.value!.end,
      tenantNote: state.tenantNote.value,
    );
  }
}
