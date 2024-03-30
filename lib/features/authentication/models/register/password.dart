import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum RegisterPasswordValidationError { required, invalid, tooShort, weak }

class RegisterPassword
    extends FormzInput<String, RegisterPasswordValidationError> {
  const RegisterPassword.pure() : super.pure('');

  const RegisterPassword.dirty([super.value = '']) : super.dirty();

  static final RegExp _passwordRegExp = Regex.passwordRegex;
  static final RegExp _specialCharRegExp = Regex.passwordSpecialCharRegex;

  static const int minLength = 8;
  static const int maxLength = 128;
  static bool requireDigit = true;
  static bool requireLowercase = true;
  static bool requireUppercase = true;
  static bool requireSpecialChar = true;

  @override
  RegisterPasswordValidationError? validator(String value) {
    if (value.isEmpty) return RegisterPasswordValidationError.required;

    // Must be at least N characters long
    if (value.length < minLength)
      return RegisterPasswordValidationError.tooShort;

    // Must contain at least one digit
    if (requireDigit && !value.contains(RegExp(r'[0-9]')))
      return RegisterPasswordValidationError.weak;

    // Must contain at least one lowercase letter
    if (requireLowercase && !value.contains(RegExp(r'[a-z]')))
      return RegisterPasswordValidationError.weak;

    // Must contain at least one uppercase letter
    if (requireUppercase && !value.contains(RegExp(r'[A-Z]')))
      return RegisterPasswordValidationError.weak;

    // Must contain at least one special character
    if (requireSpecialChar && !value.contains(_specialCharRegExp))
      return RegisterPasswordValidationError.weak;

    return _passwordRegExp.hasMatch(value)
        ? null
        : RegisterPasswordValidationError.invalid;
  }
}
