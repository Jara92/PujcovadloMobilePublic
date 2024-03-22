part of 'step3_bloc.dart';

@immutable
class Step3State {
  final ItemTags selectedTags;
  final ItemTag currentTag;
  final List<String> suggestedTags;
  final bool isSuggesting;

  bool get isValid => selectedTags.isValid;

  const Step3State({
    this.selectedTags = const ItemTags.pure(),
    this.currentTag = const ItemTag.pure(),
    this.suggestedTags = const [],
    this.isSuggesting = false,
  });

  Step3State copyWith({
    ItemTags? selectedTags,
    ItemTag? currentTag,
    List<String>? suggestedTags,
    bool? isSuggesting,
  }) {
    return Step3State(
      selectedTags: selectedTags ?? this.selectedTags,
      currentTag: currentTag ?? this.currentTag,
      suggestedTags: suggestedTags ?? this.suggestedTags,
      isSuggesting: isSuggesting ?? this.isSuggesting,
    );
  }
}

class InitialState extends Step3State {
  const InitialState()
      : super(
          selectedTags: const ItemTags.pure(),
          currentTag: const ItemTag.pure(),
          suggestedTags: const [],
          isSuggesting: false,
        );
}
