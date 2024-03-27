part of 'application_bloc.dart';

@immutable
class ApplicationState {
  final int index;

  const ApplicationState({
    this.index = 0,
  });
}

class ApplicationStateInitial extends ApplicationState {
  const ApplicationStateInitial({super.index = 2});
}
