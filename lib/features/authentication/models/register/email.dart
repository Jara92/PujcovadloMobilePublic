import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum RegisterEmailValidationError { required, invalid, tooLong }

class RegisterEmail extends FormzInput<String, RegisterEmailValidationError> {
  const RegisterEmail.pure() : super.pure('');

  const RegisterEmail.dirty([super.value = '']) : super.dirty();

  static final RegExp _nameRegExp = Regex.emailRegex;
  static const maxLength = 128;

  @override
  RegisterEmailValidationError? validator(String value) {
    // Must be filled
    if (value.isEmpty) return RegisterEmailValidationError.required;

    // Must be at most N characters long
    if (value.length > maxLength) return RegisterEmailValidationError.tooLong;

    // Must contain only letters
    return _nameRegExp.hasMatch(value)
        ? null
        : RegisterEmailValidationError.invalid;
  }
}
