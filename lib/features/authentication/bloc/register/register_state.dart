part of 'register_bloc.dart';

@immutable
class RegisterState {
  final FormzSubmissionStatus status;
  final FirstName firstName;
  final LastName lastName;
  final RegisterUsername username;
  final RegisterEmail email;
  final RegisterPhone phone;
  final RegisterPassword password;
  final RegisterPasswordConfirmation passwordConfirmation;
  final Object? error;

  bool get isValid => Formz.validate([
        firstName,
        lastName,
        username,
        email,
        phone,
        password,
        passwordConfirmation,
      ]);

  const RegisterState(
      {required this.status,
      required this.firstName,
      required this.lastName,
      required this.username,
      required this.email,
      required this.phone,
      required this.password,
      required this.passwordConfirmation,
      this.error});

  factory RegisterState.initial() {
    return const RegisterState(
      status: FormzSubmissionStatus.initial,
      firstName: FirstName.pure(),
      lastName: LastName.pure(),
      username: RegisterUsername.pure(),
      password: RegisterPassword.pure(),
      passwordConfirmation: RegisterPasswordConfirmation.pure(),
      email: RegisterEmail.pure(),
      phone: RegisterPhone.pure(),
    );
  }

  RegisterState copyWith({
    FormzSubmissionStatus? status,
    FirstName? firstName,
    LastName? lastName,
    RegisterUsername? username,
    RegisterEmail? email,
    RegisterPhone? phone,
    RegisterPassword? password,
    RegisterPasswordConfirmation? passwordConfirmation,
    Object? Function()? error,
  }) {
    return RegisterState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      error: error != null ? error() : this.error,
    );
  }
}
