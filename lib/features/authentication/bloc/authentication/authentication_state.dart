part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {
  final AuthenticationStateEnum status;

  const AuthenticationState({required this.status});
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial()
      : super(status: AuthenticationStateEnum.unauthenticated);
}

class Unknown extends AuthenticationState {
  const Unknown() : super(status: AuthenticationStateEnum.unknown);
}

class Unauthenticated extends AuthenticationState {
  const Unauthenticated()
      : super(status: AuthenticationStateEnum.unauthenticated);
}

class Authenticated extends AuthenticationState {
  final UserResponse currentUser;

  const Authenticated({required this.currentUser})
      : super(status: AuthenticationStateEnum.authenticated);
}
