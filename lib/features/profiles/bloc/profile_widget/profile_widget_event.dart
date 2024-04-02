part of 'profile_widget_bloc.dart';

@immutable
abstract class ProfileWidgetEvent {
  const ProfileWidgetEvent();
}

class WriteSmsEvent extends ProfileWidgetEvent {
  final UserResponse user;

  const WriteSmsEvent({required this.user});
}

class WriteWhatsappEvent extends ProfileWidgetEvent {
  final UserResponse user;

  const WriteWhatsappEvent({required this.user});
}

class WriteEmailEvent extends ProfileWidgetEvent {
  final UserResponse user;

  const WriteEmailEvent({required this.user});
}
