part of 'step2_bloc.dart';

@immutable
class Step2State {
  final List<ItemCategoryResponse> categories;
  final ItemCategories selectedCategories;

  bool get isValid => selectedCategories.isValid;

  const Step2State({
    this.categories = const [],
    this.selectedCategories = const ItemCategories.pure(),
  });

  Step2State copyWith({
    List<ItemCategoryResponse>? categories,
    ItemCategories? selectedCategories,
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
          selectedCategories: const ItemCategories.pure(),
        );
}
