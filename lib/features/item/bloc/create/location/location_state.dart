part of 'location_bloc.dart';

enum LocationStateEnum { initial, loading, error, loaded }

@immutable
class LocationState {
  final LocationStateEnum status;
  final List<ItemCategoryResponse> categories;
  final ItemCategories selectedCategories;
  final Exception? error;

  bool get isValid => selectedCategories.isValid;

  const LocationState({
    required this.status,
    required this.categories,
    required this.selectedCategories,
    this.error,
  });

  LocationState copyWith({
    LocationStateEnum? status,
    List<ItemCategoryResponse>? categories,
    ItemCategories? selectedCategories,
    Exception? error,
  }) {
    return LocationState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      error: error,
    );
  }
}

class InitialState extends LocationState {
  const InitialState()
      : super(
          status: LocationStateEnum.initial,
          categories: const [],
          selectedCategories: const ItemCategories.pure(),
        );
}
