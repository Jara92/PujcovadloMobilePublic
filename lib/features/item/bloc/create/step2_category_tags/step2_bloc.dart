import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/core/responses/response_list.dart';
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
  ResponseList<ItemCategoryResponse>? _categories;

  Step2Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.state.data!;

    on<Step2InitialEvent>(_onInitialEvent);
    on<SearchTextUpdated>(_onSearchTextUpdated);
    on<CategoryOptionSelected>(_onCategoryOptionSelected);
    on<ReloadCategoriesEvent>(_onReloadCategoriesEvent);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  Future<void> _onInitialEvent(
      Step2InitialEvent event, Emitter<Step2State> emit) async {
    // Init selected categories
    emit(state.copyWith(
        selectedCategories: ItemCategories.dirty(_item.categories)));

    // Load categories
    await _fetchCategories(emit);
  }

  Future<void> _fetchCategories(Emitter<Step2State> emit) async {
    emit(state.copyWith(status: Step2StateEnum.loading));

    // get all categories using the service
    try {
      //throw Exception('Failed to load categories');
      // load categories
      _categories = await _itemCategoryService.getCategories();

      // Emit loaded state
      emit(state.copyWith(
        status: Step2StateEnum.loaded,
        categories: _categories!.data,
      ));
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(
        status: Step2StateEnum.error,
        error: e,
      ));
      return;
    }
  }

  Future<void> _onSearchTextUpdated(
      SearchTextUpdated event, Emitter<Step2State> emit) async {
    // Do nothing if categories are not loaded
    if (_categories == null) return;

    emit(state.copyWith(
        categories: _categories!.data
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

  Future<void> _onReloadCategoriesEvent(
      ReloadCategoriesEvent event, Emitter<Step2State> emit) async {
    await _fetchCategories(emit);
  }

  void _onNextStep(NextStepEvent event, Emitter<Step2State> emit) {
    if (state.isValid) {
      _item.categories = state.selectedCategories.value;
      _createItemBloc.add(const MoveToStepEvent(step3_tags));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step2State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step1_name_and_description));
  }
}
