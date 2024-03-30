import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum LastNameValidationError { required, invalid, tooShort, tooLong }

class LastName extends FormzInput<String, LastNameValidationError> {
  const LastName.pure() : super.pure('');

  const LastName.dirty([super.value = '']) : super.dirty();

  static final RegExp _nameRegExp = Regex.alphabetRegex;
  static const int maxLength = 30;
  static const int minLength = 3;

  @override
  LastNameValidationError? validator(String value) {
    // Must be filled
    if (value.isEmpty) return LastNameValidationError.required;

    // Must be at least N characters long
    if (value.length < minLength) return LastNameValidationError.tooShort;

    // Must be at most N characters long
    if (value.length > maxLength) return LastNameValidationError.tooLong;

    // Must contain only letters
    return _nameRegExp.hasMatch(value) ? null : LastNameValidationError.invalid;
  }
}
