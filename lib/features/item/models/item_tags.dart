import 'package:formz/formz.dart';

enum ItemTagsValidationError {
  invalid,
  tooManyTags,
  notEnoughTags;

  const ItemTagsValidationError();
}

class ItemTags extends FormzInput<List<String>, ItemTagsValidationError> {
  const ItemTags.pure([super.value = const []]) : super.pure();

  const ItemTags.dirty([super.value = const []]) : super.dirty();

  static const _minTagsCount = 1;
  static const _maxTagsCount = 10;

  @override
  ItemTagsValidationError? validator(List<String> value) {
    // Check minimum and maximum tags count
    if (value.length > _maxTagsCount)
      return ItemTagsValidationError.tooManyTags;
    if (value.length < _minTagsCount)
      return ItemTagsValidationError.notEnoughTags;
  }
}
