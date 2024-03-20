import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';
import 'package:pujcovadlo_client/features/item/responses/item_category_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_category_service.dart';

part 'step3_event.dart';
part 'step3_state.dart';

class Step3Bloc extends Bloc<Step3Event, Step3State> {
  final ItemCategoryService _itemCategoryService =
      GetIt.instance.get<ItemCategoryService>();

  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  Step3Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.item;

    on<Step3InitialEvent>(_onInitialEvent);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  Future<void> _onInitialEvent(
      Step3InitialEvent event, Emitter<Step3State> emit) async {
    // TODO
    final categories = await _itemCategoryService.getCategories();

    emit(state.copyWith(categories: categories));
  }

  void _onNextStep(NextStepEvent event, Emitter<Step3State> emit) {
    if (state.name.isValid && state.description.isValid) {
      _item.name = state.name.value;
      _item.description = state.description.value;

      _createItemBloc.add(const MoveToStepEvent(step2_category_and_tags));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step3State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step1_name_and_description));
  }
}
