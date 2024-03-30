import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum FirstNameValidationError { required, invalid, tooShort, tooLong }

class FirstName extends FormzInput<String, FirstNameValidationError> {
  const FirstName.pure() : super.pure('');

  const FirstName.dirty([super.value = '']) : super.dirty();

  static final RegExp _nameRegExp = Regex.alphabetRegex;
  static const int maxLength = 30;
  static const int minLength = 3;

  @override
  FirstNameValidationError? validator(String value) {
    // Must be filled
    if (value.isEmpty) return FirstNameValidationError.required;

    // Must be at least N characters long
    if (value.length < minLength) return FirstNameValidationError.tooShort;

// Must be at most N characters long
    if (value.length > maxLength) return FirstNameValidationError.tooLong;

    // Must contain only letters
    return _nameRegExp.hasMatch(value)
        ? null
        : FirstNameValidationError.invalid;
  }
}
