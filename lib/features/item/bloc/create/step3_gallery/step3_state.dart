part of 'step3_bloc.dart';

@immutable
class Step3State {
  final ItemName name;
  final ItemDescription description;
  final List<ItemCategoryResponse> categories;

/*  List<ItemCategoryResponse> get gcategories {
    print("get ${categories.length} categories");
    return categories;
  }*/

  bool get isValid => false;

  const Step3State({
    this.name = const ItemName.pure(),
    this.description = const ItemDescription.pure(),
    List<ItemCategoryResponse> categories = const [],
  }) : categories = categories;

  Step3State copyWith(
      {ItemName? name,
      ItemDescription? description,
      bool? isValid,
      List<ItemCategoryResponse>? categories}) {
    return Step3State(
      name: name ?? this.name,
      description: description ?? this.description,
      categories: categories ?? this.categories,
    );
  }
}

class InitialState extends Step3State {
  const InitialState({
    super.name,
    super.description,
  }) : super(categories: const [
          ItemCategoryResponse(id: 0, name: 'Empty', alias: 'empty')
        ]);
}

class NextStepState extends Step3State {
  final int nextStep;

  const NextStepState({required this.nextStep})
      : super(
            name: const ItemName.pure(),
            description: const ItemDescription.pure());
}

class PreviousStepState extends Step3State {
  final int previousStep;

  const PreviousStepState({required this.previousStep})
      : super(
            name: const ItemName.pure(),
            description: const ItemDescription.pure());
}
