part of 'step2_bloc.dart';

@immutable
class Step2State {
  final ItemName name;
  final ItemDescription description;

  bool get isValid => false;

  const Step2State({
    this.name = const ItemName.pure(),
    this.description = const ItemDescription.pure(),
  });

  Step2State copyWith({
    ItemName? name,
    ItemDescription? description,
    bool? isValid,
  }) {
    return Step2State(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

class InitialState extends Step2State {
  const InitialState({
    super.name,
    super.description,
  });
}

class NextStepState extends Step2State {
  final int nextStep;

  const NextStepState({required this.nextStep})
      : super(
            name: const ItemName.pure(),
            description: const ItemDescription.pure());
}

class PreviousStepState extends Step2State {
  final int previousStep;

  const PreviousStepState({required this.previousStep})
      : super(
            name: const ItemName.pure(),
            description: const ItemDescription.pure());
}
