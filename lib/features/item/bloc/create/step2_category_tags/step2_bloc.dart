import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';
import 'package:pujcovadlo_client/features/item/responses/item_category_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_category_service.dart';

part 'step2_event.dart';
part 'step2_state.dart';

class Step2Bloc extends Bloc<Step2Event, Step2State> {
  final ItemCategoryService _itemCategoryService =
      GetIt.instance.get<ItemCategoryService>();

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

  Future<void> _onInitialEvent(
      Step2InitialEvent event, Emitter<Step2State> emit) async {
    // TODO
    final categories = await _itemCategoryService.getCategories();

    emit(state.copyWith(categories: categories));
  }

  void _onNextStep(NextStepEvent event, Emitter<Step2State> emit) {
    if (true) {
      _createItemBloc.add(const MoveToStepEvent(step3_gallery));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step2State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step1_name_and_description));
  }
}
