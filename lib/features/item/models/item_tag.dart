import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum ItemTagValidationError {
  invalid,
  tooShort,
  tooLong;

  const ItemTagValidationError();
}

class ItemTag extends FormzInput<String, ItemTagValidationError> {
  const ItemTag.pure([super.value = ""]) : super.pure();

  const ItemTag.dirty([super.value = ""]) : super.dirty();

  static const _minTagLength = 4;
  static const _maxTagLength = 20;

  static final _tagNameRegex = Regex.simpleTextRegex;

  @override
  ItemTagValidationError? validator(String value) {
    if (value.isEmpty) return null;

    // Check tag length
    if (value.length < _minTagLength) return ItemTagValidationError.tooShort;
    if (value.length > _maxTagLength) return ItemTagValidationError.tooLong;

    // Check tag format
    if (!_tagNameRegex.hasMatch(value)) return ItemTagValidationError.invalid;

    return null;
  }
}
