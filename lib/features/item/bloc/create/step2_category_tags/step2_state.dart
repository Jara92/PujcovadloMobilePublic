part of 'step2_bloc.dart';

enum Step2StateEnum { initial, loading, error, loaded }

@immutable
class Step2State {
  final Step2StateEnum status;
  final List<ItemCategoryResponse> categories;
  final ItemCategories selectedCategories;
  final Exception? error;

  bool get isValid => selectedCategories.isValid;

  const Step2State({
    required this.status,
    required this.categories,
    required this.selectedCategories,
    this.error,
  });

  Step2State copyWith({
    Step2StateEnum? status,
    List<ItemCategoryResponse>? categories,
    ItemCategories? selectedCategories,
    Exception? error,
  }) {
    return Step2State(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      error: error,
    );
  }
}

class InitialState extends Step2State {
  const InitialState()
      : super(
          status: Step2StateEnum.initial,
          categories: const [],
          selectedCategories: const ItemCategories.pure(),
        );
}
