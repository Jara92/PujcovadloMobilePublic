import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';

part 'create_item_event.dart';
part 'create_item_state.dart';
part 'create_item_steps.dart';

class CreateItemBloc extends Bloc<CreateItemEvent, CreateItemState> {
  final ItemService _itemService = GetIt.instance<ItemService>();

  CreateItemBloc() : super(const InitialState()) {
    on<InitialEvent>(_onInitialEvent);
    on<UpdatePreviewEvent>(_onUpdatePreviewEvent);
    on<MoveToStepEvent>(_onMoveToStep);
  }

  void _onInitialEvent(
      InitialEvent event, Emitter<CreateItemState> emit) async {
    // Loading
    emit(state.copyWith(
      status: CreateItemStateEnum.loading,
    ));

    // base item request
    var request = ItemRequest();

    try {
      // If itemId is set we are editing item so we need to load its data.
      if (event.itemId != null) {
        // get item detail
        var itemDetail = await _itemService.getItemById(event.itemId!);

        // convert item detail to editable request
        request = _itemService.responseToRequest(itemDetail);
      }

      // Emit loaded state
      emit(LoadedState(request));
    } on Exception catch (error) {
      emit(ErrorState(
        error: error,
      ));
    }
  }

  void _onUpdatePreviewEvent(
      UpdatePreviewEvent event, Emitter<CreateItemState> emit) {
    emit(state.copyWith(
      data: state.data,
    ));
  }

  void _onMoveToStep(MoveToStepEvent event, Emitter<CreateItemState> emit) {
    emit(state.copyWith(
      activeStepperIndex: event.step,
    ));
  }
}
