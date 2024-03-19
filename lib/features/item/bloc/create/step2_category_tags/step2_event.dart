part of 'step2_bloc.dart';

@immutable
abstract class Step2Event {
  const Step2Event();
}

class Step2InitialEvent extends Step2Event {
  const Step2InitialEvent();
}

class ItemNameChanged extends Step2Event {
  final String name;

  const ItemNameChanged(this.name) : super();
}

class ItemDescriptionChanged extends Step2Event {
  final String description;

  const ItemDescriptionChanged(this.description);
}

class NextStepEvent extends Step2Event {
  const NextStepEvent();
}

class PreviousStepEvent extends Step2Event {
  const PreviousStepEvent();
}
