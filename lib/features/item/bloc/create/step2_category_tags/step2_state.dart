part of 'step2_bloc.dart';

@immutable
class Step2State {
  final List<ItemCategoryResponse> categories;
  final List<String> selectedTags;
  final List<String> suggestedTags;

/*  List<ItemCategoryResponse> get gcategories {
    print("get ${categories.length} categories");
    return categories;
  }*/

  bool get isValid => false;

  const Step2State({
    this.categories = const [],
    this.selectedTags = const [],
    this.suggestedTags = const [],
  });

  Step2State copyWith(
      {bool? isValid,
      List<ItemCategoryResponse>? categories,
      List<String>? selectedTags,
      List<String>? suggestedTags}) {
    return Step2State(
      categories: categories ?? this.categories,
      selectedTags: selectedTags ?? this.selectedTags,
      suggestedTags: suggestedTags ?? this.suggestedTags,
    );
  }
}

class InitialState extends Step2State {
  const InitialState()
      : super(
            categories: const [],
            selectedTags: const [],
            suggestedTags: const []);
}

class NextStepState extends Step2State {
  final int nextStep;

  const NextStepState({required this.nextStep}) : super();
}

class PreviousStepState extends Step2State {
  final int previousStep;

  const PreviousStepState({required this.previousStep}) : super();
}
