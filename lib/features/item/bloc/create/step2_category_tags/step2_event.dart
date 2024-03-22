part of 'step2_bloc.dart';

@immutable
abstract class Step2Event {
  const Step2Event();
}

class Step2InitialEvent extends Step2Event {
  const Step2InitialEvent();
}

class SearchTextUpdated extends Step2Event {
  final String searchText;

  const SearchTextUpdated(this.searchText) : super();
}

class CategoryOptionSelected extends Step2Event {
  final int categoryId;
  final bool isChecked;

  const CategoryOptionSelected(this.categoryId, this.isChecked) : super();
}

class NextStepEvent extends Step2Event {
  const NextStepEvent();
}

class PreviousStepEvent extends Step2Event {
  const PreviousStepEvent();
}
