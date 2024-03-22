import 'package:formz/formz.dart';

enum ItemRefundableDepositValidationError {
  tooSmall,
  tooLarge;

  const ItemRefundableDepositValidationError();
}

class ItemRefundableDeposit
    extends FormzInput<double?, ItemRefundableDepositValidationError> {
  const ItemRefundableDeposit.pure([super.value]) : super.pure();

  const ItemRefundableDeposit.dirty([super.value]) : super.dirty();

  static const minValue = 1;
  static const maxValue = 9999999;

  @override
  ItemRefundableDepositValidationError? validator(double? value) {
    // The filed is not required.
    if (value == null) return null;

    if (value < minValue) return ItemRefundableDepositValidationError.tooSmall;
    if (value > maxValue) return ItemRefundableDepositValidationError.tooLarge;

    return null;
  }
}
