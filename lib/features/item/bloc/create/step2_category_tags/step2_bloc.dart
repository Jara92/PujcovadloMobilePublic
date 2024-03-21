import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';
import 'package:pujcovadlo_client/features/item/responses/item_category_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_category_service.dart';
import 'package:pujcovadlo_client/features/item/services/item_tag_service.dart';

part 'step2_event.dart';
part 'step2_state.dart';

class Step2Bloc extends Bloc<Step2Event, Step2State> {
  final ItemCategoryService _itemCategoryService =
      GetIt.instance.get<ItemCategoryService>();
  final ItemTagService _itemTagService = GetIt.instance.get<ItemTagService>();

  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  Step2Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.item;

    on<Step2InitialEvent>(_onInitialEvent);
    on<SearchTagChanged>(_onSearchTagChanged);
    on<AddTag>(_onAddTag);
    on<RemoveTag>(_onRemoveTag);
    on<SelectSuggestion>(_onSelectSuggestion);
    on<ClearSuggestions>(_onClearSuggestions);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  Future<void> _onInitialEvent(
      Step2InitialEvent event, Emitter<Step2State> emit) async {
    // TODO
    final categories = await _itemCategoryService.getCategories();

    emit(state.copyWith(categories: categories));
  }

  Future<void> _onSearchTagChanged(
      SearchTagChanged event, Emitter<Step2State> emit) async {
    // No suggestions for empty stirng
    if (event.tag.isEmpty) {
      emit(state.copyWith(suggestedTags: []));
      return;
    }

    // Get tags suggestions
    final tags = (await _itemTagService.getTags(event.tag))
        // Map responses to List of strings
        .map((e) => e.name)
        // Filter out already selected tags
        .where((element) => !state.selectedTags.contains(element))
        .toList();

    emit(state.copyWith(suggestedTags: tags));
  }

  Future<void> _onAddTag(AddTag event, Emitter<Step2State> emit) async {
    // Do nothing if the tag is empty
    if (event.tag.isEmpty) {
      return;
    }

    // Do nothing if the tag is already selected
    if (state.selectedTags.contains(event.tag)) {
      return;
    }

    //  final newTag = event.tag.fi

    emit(state.copyWith(selectedTags: [...state.selectedTags, event.tag]));
  }

  void _onRemoveTag(RemoveTag event, Emitter<Step2State> emit) {
    emit(state.copyWith(
      // Remove the selected tag from the selected tags
      selectedTags:
          state.selectedTags.where((tag) => tag != event.tag).toList(),
    ));
  }

  void _onSelectSuggestion(SelectSuggestion event, Emitter<Step2State> emit) {
    emit(
      state.copyWith(
          // Remove the selected tag from the suggested tags
          suggestedTags:
              state.suggestedTags.where((tag) => tag != event.tag).toList(),
          // Add the selected tag to the selected tags
          selectedTags: [...state.selectedTags, event.tag]),
    );
  }

  void _onClearSuggestions(ClearSuggestions event, Emitter<Step2State> emit) {
    emit(state.copyWith(suggestedTags: []));
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
