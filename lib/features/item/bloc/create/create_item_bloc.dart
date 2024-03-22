import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';

part 'create_item_event.dart';
part 'create_item_state.dart';
part 'create_item_steps.dart';

class CreateItemBloc extends Bloc<CreateItemEvent, CreateItemState> {
  late final ItemRequest item;

  CreateItemBloc({ItemRequest? item}) : super(InitialState()) {
    this.item = item ??
        ItemRequest(
          name: "Testovací",
          description: "Testovací popis na testy",
          pricePerDay: 100,
          categories: [1],
          images: [],
          tags: ["Vrtačka", "Šroubovák"],
        );

    on<InitialEvent>(_onInitialEvent);
    on<UpdatePreviewEvent>(_onUpdatePreviewEvent);
    on<MoveToStepEvent>(_onMoveToStep);
  }

  void _onInitialEvent(InitialEvent event, Emitter<CreateItemState> emit) {
    emit(CreateItemState(
      data: item,
    ));
  }

  void _onUpdatePreviewEvent(
      UpdatePreviewEvent event, Emitter<CreateItemState> emit) {
    emit(CreateItemState(
      data: item,
    ));
  }

  void _onMoveToStep(MoveToStepEvent event, Emitter<CreateItemState> emit) {
    emit(CreateItemState(
      activeStepperIndex: event.step,
      isValid: true,
    ));
  }
}
