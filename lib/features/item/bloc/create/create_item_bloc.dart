import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';

part 'create_item_event.dart';
part 'create_item_state.dart';

class CreateItemBloc extends Bloc<CreateItemEvent, CreateItemState> {
  late final ItemRequest item;

  CreateItemBloc() : super(InitialState()) {
    on<InitialEvent>(_onInitialEvent);
    //on<Step1SubmitEvent>(_onStep1Submit);
    on<ItemNameChanged>(_onItemNameChanged);
    on<ItemDescriptionChanged>(_onItemDescriptionChanged);
  }

  void _onInitialEvent(InitialEvent event, Emitter<CreateItemState> emit) {
    item = ItemRequest();

    emit(Step1_NameAndDescription(
      name: ItemName.pure(item.name ?? ''),
      description: ItemDescription.pure(item.description ?? ''),
      isValid: false,
    ));
  }

  void _onItemNameChanged(
      ItemNameChanged event, Emitter<CreateItemState> emit) {
    if (state is Step1_NameAndDescription) {
      final currentState = state as Step1_NameAndDescription;

      final name = ItemName.dirty(event.name.trim());

      emit(currentState.copyWith(
        name: name,
        isValid: Formz.validate([name]),
      ));
    }
  }

  void _onItemDescriptionChanged(
      ItemDescriptionChanged event, Emitter<CreateItemState> emit) {
    if (state is Step1_NameAndDescription) {
      final currentState = state as Step1_NameAndDescription;

      final description = ItemDescription.dirty(event.description.trim());

      emit(currentState.copyWith(
        description: description,
        isValid: Formz.validate([description]),
      ));
    }
  }

  void _onStep1Submit(Step1SubmitEvent event, Emitter<CreateItemState> emit) {
    if (state is Step1_NameAndDescription) {
      final currentState = state as Step1_NameAndDescription;

      final isValid =
          Formz.validate([currentState.name, currentState.description]);

      // Emit current state with updated data and errors and return.
      if (isValid == false) {
        emit(Step1_NameAndDescription(
            name: currentState.name,
            description: currentState.description,
            isValid: false));
        return;
      }

      // Update item data
      item.name = currentState.name.value;
      item.description = currentState.description.value;
    }

    // Load next step
    // todo
  }
}
