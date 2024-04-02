part of 'profile_widget_bloc.dart';

@immutable
abstract class ProfileWidgetState {
  const ProfileWidgetState();
}

class ProfileWidgetInitial extends ProfileWidgetState {
  const ProfileWidgetInitial();
}

class ErrorState extends ProfileWidgetState {
  final Exception error;

  const ErrorState({required this.error});
}
