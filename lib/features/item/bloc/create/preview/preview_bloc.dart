import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';

part 'preview_event.dart';
part 'preview_state.dart';

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  PreviewBloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.state.data!;

    on<PreviewUpdate>(_onPreviewUpdate);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  void _onPreviewUpdate(PreviewUpdate event, Emitter<PreviewState> emit) {
    emit(PreviewState(
      data: _item,
    ));
  }

  void _onNextStep(NextStepEvent event, Emitter<PreviewState> emit) {
    // Validate the form
    if (state.isValid) {
      _createItemBloc.add(const MoveToStepEvent(step6_preview));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<PreviewState> emit) {
    _createItemBloc.add(const MoveToStepEvent(step5_prices));
  }
}
