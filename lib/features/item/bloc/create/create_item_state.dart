part of 'create_item_bloc.dart';

@immutable
class CreateItemState {

  final int step;
  final bool isValid;
  final int activeStepperIndex;

  CreateItemState({
    this.step = 0,
    this.isValid = true,
    this.activeStepperIndex = 0,
  });

  CreateItemState copyWith({
    ItemName? name,
    ItemDescription? description,
    int? step,
    bool? isValid,
  }) {
    return CreateItemState(
      step: step ?? this.step,
      isValid: isValid ?? this.isValid,
      activeStepperIndex: step ?? this.activeStepperIndex,
    );
  }
}

class InitialState extends CreateItemState {
  InitialState({ItemRequest? item}) : super(step: 0, isValid: true);
}

class NextStepState extends CreateItemState {
  NextStepState({required int step}) : super(step: step, isValid: true);
}

class PreviousStepState extends CreateItemState {
  PreviousStepState({required int step}) : super(step: step, isValid: true);
}
