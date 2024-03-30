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

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final ItemCategoryService _itemCategoryService =
      GetIt.instance.get<ItemCategoryService>();

  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;
  ResponseList<ItemCategoryResponse>? _categories;

  LocationBloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.state.data!;

    on<LocationInitialEvent>(_onInitialEvent);
    on<SearchTextUpdated>(_onSearchTextUpdated);
    on<CategoryOptionSelected>(_onCategoryOptionSelected);
    on<ReloadCategoriesEvent>(_onReloadCategoriesEvent);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  Future<void> _onInitialEvent(
      LocationInitialEvent event, Emitter<LocationState> emit) async {
    // Init selected categories
    emit(state.copyWith(
        selectedCategories: ItemCategories.pure(_item.categories)));

    // Load categories
    await _fetchCategories(emit);
  }

  Future<void> _fetchCategories(Emitter<LocationState> emit) async {
    emit(state.copyWith(status: LocationStateEnum.loading));

    // get all categories using the service
    try {
      //throw Exception('Failed to load categories');
      // load categories
      _categories = await _itemCategoryService.getCategories();

      // Emit loaded state
      emit(state.copyWith(
        status: LocationStateEnum.loaded,
        categories: _categories!.data,
      ));
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(
        status: LocationStateEnum.error,
        error: e,
      ));
      return;
    }
  }

  Future<void> _onSearchTextUpdated(
      SearchTextUpdated event, Emitter<LocationState> emit) async {
    //  todo: not working

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
      CategoryOptionSelected event, Emitter<LocationState> emit) {
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
      ReloadCategoriesEvent event, Emitter<LocationState> emit) async {
    await _fetchCategories(emit);
  }

  void _onNextStep(NextStepEvent event, Emitter<LocationState> emit) {
    if (state.isValid) {
      _item.categories = state.selectedCategories.value;
      _createItemBloc.add(const MoveToStepEvent(step4_gallery));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<LocationState> emit) {
    _createItemBloc.add(const MoveToStepEvent(step3_tags));
  }
}
