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

class ItemNameChanged extends CreateItemEvent {
  final String name;

  const ItemNameChanged(this.name);
}

class ItemDescriptionChanged extends CreateItemEvent {
  final String description;

  const ItemDescriptionChanged(this.description);
}

/*class NextStepEvent extends CreateItemEvent {
  const NextStepEvent();
}

class PreviousStepEvent extends CreateItemEvent {
  const PreviousStepEvent();
}*/
