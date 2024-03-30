part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {
  const LocationEvent();
}

class LocationInitialEvent extends LocationEvent {
  const LocationInitialEvent();
}

class NextStepEvent extends LocationEvent {
  const NextStepEvent();
}

class LocationChangedEvent extends LocationEvent {
  final double? latitude;
  final double? longitude;

  const LocationChangedEvent({
    required this.latitude,
    required this.longitude,
  });
}

class PreviousStepEvent extends LocationEvent {
  const PreviousStepEvent();
}
