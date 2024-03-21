part of 'step3_bloc.dart';

@immutable
abstract class Step3Event {
  const Step3Event();
}

class Step3InitialEvent extends Step3Event {
  const Step3InitialEvent();
}

class SearchTagChanged extends Step3Event {
  final String tag;
  final Future<List<String>> task;

  const SearchTagChanged(this.tag, this.task) : super();
}

class AddTag extends Step3Event {
  final String tag;

  const AddTag(this.tag) : super();
}

class RemoveTag extends Step3Event {
  final String tag;

  const RemoveTag(this.tag) : super();
}

class SelectSuggestion extends Step3Event {
  final String tag;

  const SelectSuggestion(this.tag) : super();
}

class SelectedTagsChanged extends Step3Event {
  final List<String> tags;

  const SelectedTagsChanged(this.tags) : super();
}

class ClearSuggestions extends Step3Event {
  const ClearSuggestions();
}

class NextStepEvent extends Step3Event {
  const NextStepEvent();
}

class PreviousStepEvent extends Step3Event {
  const PreviousStepEvent();
}
