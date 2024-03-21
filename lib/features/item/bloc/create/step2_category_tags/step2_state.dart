part of 'step2_bloc.dart';

@immutable
class Step2State {
  final List<ItemCategoryResponse> categories;
  final List<int> selectedCategories;

/*  List<ItemCategoryResponse> get gcategories {
    print("get ${categories.length} categories");
    return categories;
  }*/

  // todo: fix this
  bool get isValid => true;

  const Step2State({
    this.categories = const [],
    this.selectedCategories = const [],
  });

  Step2State copyWith({
    bool? isValid,
    List<ItemCategoryResponse>? categories,
    List<int>? selectedCategories,
  }) {
    return Step2State(
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }
}

class InitialState extends Step2State {
  const InitialState()
      : super(
          categories: const [],
          selectedCategories: const [],
        );
}
