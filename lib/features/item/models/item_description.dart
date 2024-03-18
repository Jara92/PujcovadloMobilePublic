import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum ItemDescriptionValidationError {
  required,
  invalid,
  tooShort,
  tooLong;

  const ItemDescriptionValidationError();
}

class ItemDescription
    extends FormzInput<String, ItemDescriptionValidationError> {
  const ItemDescription.pure([super.value = '']) : super.pure();

  const ItemDescription.dirty([super.value = '']) : super.dirty();

  static final _nameRegex = Regex.multilineTextRegex;
  static const int minLength = 10;
  static const int maxLength = 1000;

  @override
  ItemDescriptionValidationError? validator(String value) {
    // No value entered
    if (value.isEmpty) {
      return ItemDescriptionValidationError.required;
    }

    // Check length
    if (value.length < minLength)
      return ItemDescriptionValidationError.tooShort;
    if (value.length > maxLength) return ItemDescriptionValidationError.tooLong;

    // Check regex
    return _nameRegex.hasMatch(value)
        ? null
        : ItemDescriptionValidationError.invalid;
  }
}
