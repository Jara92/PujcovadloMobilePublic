import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum ItemNameValidationError {
  required,
  invalid,
  tooShort,
  tooLong;

  const ItemNameValidationError();
}

class ItemName extends FormzInput<String, ItemNameValidationError> {
  const ItemName.pure([super.value = '']) : super.pure();

  const ItemName.dirty([super.value = '']) : super.dirty();

  static final _nameRegex = Regex.textRegex;

  static final _minLength = 5;
  static final _maxLength = 30;

  @override
  ItemNameValidationError? validator(String value) {
    if (value.isEmpty) return ItemNameValidationError.required;

    if (value.length < _minLength) return ItemNameValidationError.tooShort;
    if (value.length > _maxLength) return ItemNameValidationError.tooLong;

    return _nameRegex.hasMatch(value) ? null : ItemNameValidationError.invalid;
  }
}
