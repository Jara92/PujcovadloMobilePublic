import 'package:formz/formz.dart';

enum LoginPasswordValidationError { required }

class LoginPassword extends FormzInput<String, LoginPasswordValidationError> {
  const LoginPassword.pure() : super.pure('');

  const LoginPassword.dirty([super.value = '']) : super.dirty();

  @override
  LoginPasswordValidationError? validator(String value) {
    if (value.isEmpty) return LoginPasswordValidationError.required;
    return null;
  }
}
