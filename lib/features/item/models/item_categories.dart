import 'package:formz/formz.dart';

enum ItemCategoriesValidationError {
  tooManyCategories,
  notEnoughtCategories;

  const ItemCategoriesValidationError();
}

class ItemCategories
    extends FormzInput<List<int>, ItemCategoriesValidationError> {
  const ItemCategories.pure([super.value = const []]) : super.pure();

  const ItemCategories.dirty([super.value = const []]) : super.dirty();

  static const _minCategoriesCount = 1;
  static const _maxCategoriesCount = 5;

  @override
  ItemCategoriesValidationError? validator(List<int> value) {
    // Check minimum and maximum tags count
    if (value.length > _maxCategoriesCount) {
      return ItemCategoriesValidationError.tooManyCategories;
    }
    if (value.length < _minCategoriesCount) {
      return ItemCategoriesValidationError.notEnoughtCategories;
    }

    return null;
  }
}
