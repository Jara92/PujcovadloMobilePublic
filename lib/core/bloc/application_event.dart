part of 'application_bloc.dart';

@immutable
abstract class ApplicationEvent {
  const ApplicationEvent();
}

class TabChangedApplicationEvent extends ApplicationEvent {
  final int index;

  const TabChangedApplicationEvent(this.index);
}
