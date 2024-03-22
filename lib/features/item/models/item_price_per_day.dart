import 'package:formz/formz.dart';

enum ItemPricePerDayValidationError {
  required,
  tooSmall,
  tooLarge;

  const ItemPricePerDayValidationError();
}

class ItemPricePerDay
    extends FormzInput<double?, ItemPricePerDayValidationError> {
  const ItemPricePerDay.pure([super.value]) : super.pure();

  const ItemPricePerDay.dirty([super.value]) : super.dirty();

  static const minValue = 0;
  static const maxValue = 9999999;

  @override
  ItemPricePerDayValidationError? validator(double? value) {
    if (value == null) return ItemPricePerDayValidationError.required;

    if (value < minValue) return ItemPricePerDayValidationError.tooSmall;
    if (value > maxValue) return ItemPricePerDayValidationError.tooLarge;

    return null;
  }
}
