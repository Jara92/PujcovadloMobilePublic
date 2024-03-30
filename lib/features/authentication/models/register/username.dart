import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum RegisterUsernameValidationError { required, invalid, tooShort, tooLong }

class RegisterUsername
    extends FormzInput<String, RegisterUsernameValidationError> {
  const RegisterUsername.pure() : super.pure('');

  const RegisterUsername.dirty([super.value = '']) : super.dirty();

  static final RegExp _usernameRegex = Regex.usernameRegex;
  static const int minLength = 4;
  static const int maxLength = 30;

  @override
  RegisterUsernameValidationError? validator(String value) {
    if (value.isEmpty) return RegisterUsernameValidationError.required;

    // Must be at least N characters long
    if (value.length < minLength)
      return RegisterUsernameValidationError.tooShort;

    // Must be at most N characters long
    if (value.length > maxLength)
      return RegisterUsernameValidationError.tooLong;

    // Must contain only letters
    return _usernameRegex.hasMatch(value)
        ? null
        : RegisterUsernameValidationError.invalid;
  }
}
