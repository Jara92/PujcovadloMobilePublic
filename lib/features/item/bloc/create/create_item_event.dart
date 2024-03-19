part of 'create_item_bloc.dart';

@immutable
abstract class CreateItemEvent {
  const CreateItemEvent();
}

class InitialEvent extends CreateItemEvent {
  const InitialEvent();
}

class Step1SubmitEvent extends CreateItemEvent {
  const Step1SubmitEvent();
}

class MoveToStepEvent extends CreateItemEvent {
  final int step;

  const MoveToStepEvent(this.step);
}
