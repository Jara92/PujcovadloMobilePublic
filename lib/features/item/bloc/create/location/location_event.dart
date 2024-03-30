part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {
  const LocationEvent();
}

class LocationInitialEvent extends LocationEvent {
  const LocationInitialEvent();
}

class SearchTextUpdated extends LocationEvent {
  final String searchText;

  const SearchTextUpdated(this.searchText) : super();
}

class CategoryOptionSelected extends LocationEvent {
  final int categoryId;
  final bool isChecked;

  const CategoryOptionSelected(this.categoryId, this.isChecked) : super();
}

class ReloadCategoriesEvent extends LocationEvent {
  const ReloadCategoriesEvent();
}

class NextStepEvent extends LocationEvent {
  const NextStepEvent();
}

class PreviousStepEvent extends LocationEvent {
  const PreviousStepEvent();
}
