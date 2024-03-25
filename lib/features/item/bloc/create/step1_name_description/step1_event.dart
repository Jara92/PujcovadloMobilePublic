part of 'step1_bloc.dart';

@immutable
abstract class Step1Event {
  const Step1Event();
}

class Step1InitialEvent extends Step1Event {
  const Step1InitialEvent() : super();
}

class ItemNameChanged extends Step1Event {
  final String name;

  const ItemNameChanged(this.name) : super();
}

class ItemDescriptionChanged extends Step1Event {
  final String description;

  const ItemDescriptionChanged(this.description);
}

class NextStepEvent extends Step1Event {
  const NextStepEvent();
}

class PreviousStepEvent extends Step1Event {
  const PreviousStepEvent();
}
