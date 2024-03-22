part of 'create_item_bloc.dart';

@immutable
class CreateItemState {
  final int step;
  final bool isValid;
  final int activeStepperIndex;
  final ItemRequest? data;

  const CreateItemState({
    this.step = 0,
    this.isValid = true,
    this.activeStepperIndex = 0,
    this.data,
  });

  CreateItemState copyWith({
    ItemName? name,
    ItemDescription? description,
    int? activeStepperIndex,
    bool? isValid,
  }) {
    return CreateItemState(
      step: activeStepperIndex ?? this.step,
      isValid: isValid ?? this.isValid,
      activeStepperIndex: activeStepperIndex ?? this.activeStepperIndex,
    );
  }
}

class InitialState extends CreateItemState {
  const InitialState({ItemRequest? item})
      : super(data: item, step: 0, isValid: true);
}