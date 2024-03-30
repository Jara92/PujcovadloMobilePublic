part of 'location_bloc.dart';

@immutable
class LocationState {
  final double? latitude;
  final double? longitude;
  final Exception? error;

  bool get locationInitialized => latitude != null && longitude != null;

  bool get isValid => latitude != null && longitude != null;

  const LocationState({
    required this.latitude,
    required this.longitude,
    this.error,
  });

  LocationState copyWith({
    double? latitude,
    double? longitude,
    Exception? error,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      error: error,
    );
  }
}

class InitialState extends LocationState {
  const InitialState()
      : super(
          latitude: null,
          longitude: null,
        );
}
