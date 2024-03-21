import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';

part 'step1_event.dart';
part 'step1_state.dart';

class Step1Bloc extends Bloc<Step1Event, Step1State> {
  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  Step1Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.item;

    on<Step1InitialEvent>(_onInitialEvent);
    on<ItemNameChanged>(_onItemNameChanged);
    on<ItemDescriptionChanged>(_onItemDescriptionChanged);
    on<NextStepEvent>(_onNextStep);
  }

  void _onInitialEvent(Step1InitialEvent event, Emitter<Step1State> emit) {
    emit(Step1State(
      name: ItemName.dirty(_item.name ?? ""),
      description: ItemDescription.dirty(_item.description ?? ""),
    ));
  }

  void _onItemNameChanged(ItemNameChanged event, Emitter<Step1State> emit) {
    // Create new model and validate it
    final name = ItemName.dirty(event.name.trim());

    // Emit new state
    emit(state.copyWith(
      name: name,
      isValid: Formz.validate([name]),
    ));
  }

  void _onItemDescriptionChanged(
      ItemDescriptionChanged event, Emitter<Step1State> emit) {
    // Create new model and validate it
    final description = ItemDescription.dirty(event.description.trim());

    // Emit new state
    emit(state.copyWith(
      description: description,
      isValid: Formz.validate([description]),
    ));
  }

  void _onNextStep(NextStepEvent event, Emitter<Step1State> emit) {
    if (state.name.isValid && state.description.isValid) {
      _item.name = state.name.value;
      _item.description = state.description.value;

      _createItemBloc.add(const MoveToStepEvent(step2_categories));
    }
  }
}
