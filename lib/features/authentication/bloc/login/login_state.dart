part of 'login_bloc.dart';

@immutable
class LoginState {
  final FormzSubmissionStatus status;
  final LoginUsername username;
  final LoginPassword password;
  final Object? error;

  bool get isValid => username.isValid && password.isValid;

  const LoginState(
      {required this.status,
      required this.username,
      required this.password,
      this.error});

  factory LoginState.initial() {
    return const LoginState(
      status: FormzSubmissionStatus.initial,
      username: LoginUsername.pure(),
      password: LoginPassword.pure(),
    );
  }

  LoginState copyWith({
    FormzSubmissionStatus? status,
    LoginUsername? username,
    LoginPassword? password,
    Object? Function()? error,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      error: error != null ? error() : this.error,
    );
  }
}
