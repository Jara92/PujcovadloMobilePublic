import 'package:formz/formz.dart';

enum ItemSellingPriceValidationError {
  tooSmall,
  tooLarge;

  const ItemSellingPriceValidationError();
}

class ItemSellingPrice
    extends FormzInput<double?, ItemSellingPriceValidationError> {
  const ItemSellingPrice.pure([super.value]) : super.pure();

  const ItemSellingPrice.dirty([super.value]) : super.dirty();

  static const minValue = 1;
  static const maxValue = 9999999;

  @override
  ItemSellingPriceValidationError? validator(double? value) {
    // The filed is not required.
    if (value == null) return null;

    if (value < minValue) return ItemSellingPriceValidationError.tooSmall;
    if (value > maxValue) return ItemSellingPriceValidationError.tooLarge;

    return null;
  }
}
