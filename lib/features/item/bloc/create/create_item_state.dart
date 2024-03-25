part of 'create_item_bloc.dart';

enum CreateItemStateEnum { initial, loading, loaded, error }

@immutable
class CreateItemState {
  final CreateItemStateEnum status;
  final int activeStepperIndex;
  final ItemRequest? data;
  final Exception? error;

  const CreateItemState({
    required this.status,
    required this.activeStepperIndex,
    this.data,
    this.error,
  });

  CreateItemState copyWith({
    CreateItemStateEnum? status,
    int? activeStepperIndex,
    ItemRequest? data,
    Exception? error,
  }) {
    return CreateItemState(
      status: status ?? this.status,
      activeStepperIndex: activeStepperIndex ?? this.activeStepperIndex,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

class InitialState extends CreateItemState {
  const InitialState()
      : super(
          status: CreateItemStateEnum.initial,
          activeStepperIndex: 0,
        );
}

class LoadedState extends CreateItemState {
  const LoadedState(ItemRequest data)
      : super(
          status: CreateItemStateEnum.loaded,
          activeStepperIndex: 0,
          data: data,
        );
}

class ErrorState extends CreateItemState {
  const ErrorState({
    required Exception error,
  }) : super(
          status: CreateItemStateEnum.error,
          activeStepperIndex: 0,
          error: error,
        );
}
