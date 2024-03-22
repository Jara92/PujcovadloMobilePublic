import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
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
    _item = _createItemBloc.item;

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
    if (tag.isEmpty) return [];

    // Do nothing if the input is too short
    // TODO
    //if (tag.length < 3) return [];

    return (await _itemTagService.getTags(tag))
        // Get only tag names
        .map((e) => e.name)
        // Filter out already selected tags
        .where((tag) => !state.selectedTags.value.contains(tag))
        .toList();
  }

  Future<void> _onInitialEvent(Step3InitialEvent event,
      Emitter<Step3State> emit) async {
    // Init selected tags
    emit(state.copyWith(selectedTags: ItemTags.dirty(_item.tags)));
  }

  Future<void> _onSearchTagChanged(
      SearchTagChanged event, Emitter<Step3State> emit) async {
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
    // Do nothing if the tag is empty
    if (event.tag.isEmpty) {
      return;
    }

    // Do nothing if the tag is already selected
    if (state.selectedTags.value.contains(event.tag)) return;

    final search = ItemTag.dirty(event.tag);
    emit(state.copyWith(currentTag: search));

    // Dont continue if the tag is not valid
    if (search.isNotValid) return;

    emit(state.copyWith(
      selectedTags: ItemTags.dirty([...state.selectedTags.value, event.tag]),
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
