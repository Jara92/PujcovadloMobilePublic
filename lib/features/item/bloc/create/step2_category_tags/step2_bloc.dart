import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/item_categories.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
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
  late final List<ItemCategoryResponse> _categories;

  Step2Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.item;

    on<Step2InitialEvent>(_onInitialEvent);
    on<SearchTextUpdated>(_onSearchTextUpdated);
    on<CategoryOptionSelected>(_onCategoryOptionSelected);
    on<SelectedOptionsChanged>(_onSelectedOptionsChanged);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  Future<void> _onInitialEvent(
      Step2InitialEvent event, Emitter<Step2State> emit) async {
    // TODO
    _categories = await _itemCategoryService.getCategories();

    emit(state.copyWith(categories: _categories));
  }

  void _onSearchTextUpdated(SearchTextUpdated event, Emitter<Step2State> emit) {
    emit(state.copyWith(
        categories: _categories
            .where((category) => category.name
                .toLowerCase()
                .contains(event.searchText.toLowerCase()))
            .toList()));
  }

  void _onCategoryOptionSelected(
      CategoryOptionSelected event, Emitter<Step2State> emit) {
    var selectedCategories = state.selectedCategories;
    final categoryId = event.categoryId;
    final isChecked = event.isChecked;

    if (isChecked && !selectedCategories.value.contains(categoryId)) {
      selectedCategories =
          ItemCategories.dirty([...selectedCategories.value, categoryId]);
    } else {
      selectedCategories = ItemCategories.dirty(
          selectedCategories.value.where((id) => id != categoryId).toList());
    }

    emit(state.copyWith(selectedCategories: selectedCategories));
  }

  void _onSelectedOptionsChanged(
      SelectedOptionsChanged event, Emitter<Step2State> emit) {
    /* final selectedOptions = event.selectedOptions;

    emit(state.copyWith(selectedCategories: selectedOptions));

    print(selectedOptions);*/
  }

  void _onNextStep(NextStepEvent event, Emitter<Step2State> emit) {
    if (state.selectedCategories.isValid) {
      _item.categories = state.selectedCategories.value;
      _createItemBloc.add(const MoveToStepEvent(step3_tags));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step2State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step1_name_and_description));
  }
}
