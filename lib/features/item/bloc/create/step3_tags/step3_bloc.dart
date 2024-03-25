import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/filters/item_tag_filter.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';
import 'package:pujcovadlo_client/features/item/services/item_tag_service.dart';

part 'step3_event.dart';
part 'step3_state.dart';

class Step3Bloc extends Bloc<Step3Event, Step3State> {
  final ItemTagService _itemTagService = GetIt.instance.get<ItemTagService>();

  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  Step3Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.state.data!;

    on<Step3InitialEvent>(_onInitialEvent);
    on<SearchTagChanged>(_onSearchTagChanged);
    on<AddTag>(_onAddTag);
    on<RemoveTag>(_onRemoveTag);
    on<SelectSuggestion>(_onSelectSuggestion);
    on<SelectedTagsChanged>(_onSelectedTagsChanged);
    on<ClearSuggestions>(_onClearSuggestions);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  /// Suggest tags based on the given input.
  /// ATTENTION: Make sure that you pass the Future<List<String>> to the SearchTagChanged event so the Bloc state can be handled properly.
  /// This is because Autocomplete widget's options cannot be updated manually.
  Future<List<String>> suggestTags(String tag) async {
    // Do nothing if the tag is empty
    if (tag.isEmpty) return List<String>.empty();

    // Do nothing if the input is too short
    if (tag.length <= 2) return List<String>.empty();

    try {
      final tags = await _itemTagService.getTags(ItemTagFilter(search: tag));

      // Get only tag names
      return tags.data
          .map((e) => e.name)
          // Filter out already selected tags
          .where((tag) => !state.selectedTags.value.contains(tag))
          .toList();
    } on Exception catch (e) {
      print(e);
      return List<String>.empty();
    }
  }

  Future<void> _onInitialEvent(
      Step3InitialEvent event, Emitter<Step3State> emit) async {
    // Init selected tags
    emit(state.copyWith(selectedTags: ItemTags.pure(_item.tags)));
  }

  Future<void> _onSearchTagChanged(
      SearchTagChanged event, Emitter<Step3State> emit) async {
    // Save new search tag
    final search = ItemTag.dirty(event.tag);
    emit(state.copyWith(currentTag: search));

    // Set the state to suggest tags
    emit(state.copyWith(isSuggesting: true));

    // Wait for the tags to be suggested
    final tags = await event.task;

    // Update the status
    emit(state.copyWith(suggestedTags: tags, isSuggesting: false));
  }

  Future<void> _onAddTag(AddTag event, Emitter<Step3State> emit) async {
    // Save the tag
    final search = ItemTag.dirty(event.tag);
    emit(state.copyWith(currentTag: search));

    // Do nothing if the tag is empty
    if (event.tag.isEmpty) {
      return;
    }

    // Do nothing if the tag is already selected
    if (state.selectedTags.value.contains(event.tag)) return;

    // Dont continue if the tag is not valid
    if (search.isNotValid) return;

    emit(state.copyWith(
      selectedTags: ItemTags.dirty([...state.selectedTags.value, event.tag]),
      // Clear the current tag when successfully added
      currentTag: const ItemTag.pure(),
    ));
  }

  void _onRemoveTag(RemoveTag event, Emitter<Step3State> emit) {
    // Do nothing if the tag is not selected
    if (!state.selectedTags.value.contains(event.tag)) {
      return;
    }

    emit(state.copyWith(
        // Remove the selected tag from the selected tags
        selectedTags: ItemTags.dirty(state.selectedTags.value
            .where((tag) => tag != event.tag)
            .toList())));
  }

  void _onSelectSuggestion(SelectSuggestion event, Emitter<Step3State> emit) {
    // Do nothing if the tag is already selected
    if (state.selectedTags.value.contains(event.tag)) {
      return;
    }

    emit(
      state.copyWith(
        // Remove the selected tag from the suggested tags
        //suggestedTags: state.suggestedTags.where((tag) => tag != event.tag).toList(),
        suggestedTags: [],
        // Add the selected tag to the selected tags
        selectedTags: ItemTags.dirty([...state.selectedTags.value, event.tag]),
        currentTag: const ItemTag.pure(),
      ),
    );
  }

  void _onSelectedTagsChanged(
      SelectedTagsChanged event, Emitter<Step3State> emit) {
    emit(state.copyWith(selectedTags: ItemTags.dirty(event.tags)));
  }

  void _onClearSuggestions(ClearSuggestions event, Emitter<Step3State> emit) {
    emit(state.copyWith(suggestedTags: []));
  }

  void _onNextStep(NextStepEvent event, Emitter<Step3State> emit) {
    if (state.isValid) {
      _item.tags = state.selectedTags.value;

      _createItemBloc.add(const MoveToStepEvent(step4_gallery));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step3State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step2_categories));
  }
}
