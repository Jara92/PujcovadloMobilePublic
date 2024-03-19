import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';

part 'step2_event.dart';
part 'step2_state.dart';

class Step2Bloc extends Bloc<Step2Event, Step2State> {
  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  Step2Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.item;

    on<Step2InitialEvent>(_onInitialEvent);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  void _onInitialEvent(Step2InitialEvent event, Emitter<Step2State> emit) {
    // TODO
  }

  void _onNextStep(NextStepEvent event, Emitter<Step2State> emit) {
    if (state.name.isValid && state.description.isValid) {
      _item.name = state.name.value;
      _item.description = state.description.value;

      _createItemBloc.add(const MoveToStepEvent(step2_category_and_tags));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step2State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step1_name_and_description));
  }
}
