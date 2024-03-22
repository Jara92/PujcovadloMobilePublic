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

  static const minTagsCount = 1;
  static const maxTagsCount = 10;

  @override
  ItemTagsValidationError? validator(List<String> value) {
    // Check minimum and maximum tags count
    if (value.length > maxTagsCount) {
      return ItemTagsValidationError.tooManyTags;
    }
    if (value.length < minTagsCount) {
      return ItemTagsValidationError.notEnoughTags;
    }

    return null;
  }
}
