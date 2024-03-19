part of 'step2_bloc.dart';

@immutable
class Step2State {
  final List<ItemCategoryResponse> categories;

/*  List<ItemCategoryResponse> get gcategories {
    print("get ${categories.length} categories");
    return categories;
  }*/

  bool get isValid => false;

  const Step2State({
    List<ItemCategoryResponse> categories = const [],
  }) : categories = categories;

  Step2State copyWith({
    bool? isValid,
      List<ItemCategoryResponse>? categories}) {
    return Step2State(
      categories: categories ?? this.categories,
    );
  }
}

class InitialState extends Step2State {
  const InitialState()
      : super(categories: const [
          ItemCategoryResponse(id: 0, name: 'Empty', alias: 'empty')
        ]);
}

class NextStepState extends Step2State {
  final int nextStep;

  const NextStepState({required this.nextStep}) : super();
}

class PreviousStepState extends Step2State {
  final int previousStep;

  const PreviousStepState({required this.previousStep}) : super();
}
