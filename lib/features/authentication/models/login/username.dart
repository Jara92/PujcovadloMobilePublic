import 'package:formz/formz.dart';

enum LoginUsernameValidationError { required }

class LoginUsername extends FormzInput<String, LoginUsernameValidationError> {
  const LoginUsername.pure() : super.pure('');

  const LoginUsername.dirty([super.value = '']) : super.dirty();

  @override
  LoginUsernameValidationError? validator(String value) {
    if (value.isEmpty) return LoginUsernameValidationError.required;
    return null;
  }
}
