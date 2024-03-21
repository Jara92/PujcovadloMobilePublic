part of 'step3_bloc.dart';

@immutable
class Step3State {
  final List<String> selectedTags;
  final List<String> suggestedTags;
  final bool isSuggesting;

/*  List<ItemCategoryResponse> get gcategories {
    print("get ${categories.length} categories");
    return categories;
  }*/

  bool get isValid => selectedTags.isNotEmpty;

  const Step3State({
    this.selectedTags = const [],
    this.suggestedTags = const [],
    this.isSuggesting = false,
  });

  Step3State copyWith({
    bool? isValid,
    List<String>? selectedTags,
    List<String>? suggestedTags,
    bool? isSuggesting,
  }) {
    return Step3State(
      selectedTags: selectedTags ?? this.selectedTags,
      suggestedTags: suggestedTags ?? this.suggestedTags,
      isSuggesting: isSuggesting ?? this.isSuggesting,
    );
  }
}

class InitialState extends Step3State {
  const InitialState()
      : super(
          selectedTags: const [],
          suggestedTags: const [],
          isSuggesting: false,
        );
}

/*class NextStepState extends Step3State {
  final int nextStep;

  const NextStepState({required this.nextStep}) : super();
}

class PreviousStepState extends Step3State {
  final int previousStep;

  const PreviousStepState({required this.previousStep}) : super();
}*/
