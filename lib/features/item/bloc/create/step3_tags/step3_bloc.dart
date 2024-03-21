import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
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

  Future<void> _onInitialEvent(
      Step3InitialEvent event, Emitter<Step3State> emit) async {}

  Future<void> _onSearchTagChanged(
      SearchTagChanged event, Emitter<Step3State> emit) async {
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

  Future<void> _onAddTag(AddTag event, Emitter<Step3State> emit) async {
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

  void _onRemoveTag(RemoveTag event, Emitter<Step3State> emit) {
    emit(state.copyWith(
      // Remove the selected tag from the selected tags
      selectedTags:
          state.selectedTags.where((tag) => tag != event.tag).toList(),
    ));
  }

  void _onSelectSuggestion(SelectSuggestion event, Emitter<Step3State> emit) {
    emit(
      state.copyWith(
          // Remove the selected tag from the suggested tags
          //suggestedTags: state.suggestedTags.where((tag) => tag != event.tag).toList(),
          suggestedTags: [],
          // Add the selected tag to the selected tags
          selectedTags: [...state.selectedTags, event.tag]),
    );
  }

  void _onSelectedTagsChanged(
      SelectedTagsChanged event, Emitter<Step3State> emit) {
    emit(state.copyWith(selectedTags: event.tags));
  }

  void _onClearSuggestions(ClearSuggestions event, Emitter<Step3State> emit) {
    emit(state.copyWith(suggestedTags: []));
  }

  void _onNextStep(NextStepEvent event, Emitter<Step3State> emit) {
    if (true) {
      _createItemBloc.add(const MoveToStepEvent(step4_gallery));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step3State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step2_categories));
  }
}
