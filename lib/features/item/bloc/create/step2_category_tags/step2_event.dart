part of 'step2_bloc.dart';

@immutable
abstract class Step2Event {
  const Step2Event();
}

class Step2InitialEvent extends Step2Event {
  const Step2InitialEvent();
}

class SearchTagChanged extends Step2Event {
  final String tag;

  const SearchTagChanged(this.tag) : super();
}

class AddTag extends Step2Event {
  final String tag;

  const AddTag(this.tag) : super();
}

class RemoveTag extends Step2Event {
  final String tag;

  const RemoveTag(this.tag) : super();
}

class SelectSuggestion extends Step2Event {
  final String tag;

  const SelectSuggestion(this.tag) : super();
}

class ClearSuggestions extends Step2Event {
  const ClearSuggestions();
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
