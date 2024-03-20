part of 'step3_bloc.dart';

@immutable
abstract class Step3Event {
  const Step3Event();
}

class Step3InitialEvent extends Step3Event {
  const Step3InitialEvent();
}

class ItemNameChanged extends Step3Event {
  final String name;

  const ItemNameChanged(this.name) : super();
}

class ItemDescriptionChanged extends Step3Event {
  final String description;

  const ItemDescriptionChanged(this.description);
}

class NextStepEvent extends Step3Event {
  const NextStepEvent();
}

class PreviousStepEvent extends Step3Event {
  const PreviousStepEvent();
}
