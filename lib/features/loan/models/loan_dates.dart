import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/objects/datetime_range.dart';

enum LoanDateValidationError {
  required,
  invalid;

  const LoanDateValidationError();
}

class LoanDates extends FormzInput<DateTimeRange?, LoanDateValidationError> {
  const LoanDates.pure([super.value]) : super.pure();

  const LoanDates.dirty([super.value]) : super.dirty();

  @override
  LoanDateValidationError? validator(DateTimeRange? value) {
    // Must be filled
    if (value == null) return LoanDateValidationError.required;

    // Both start and end must be filled
    if (value.start == null || value.end == null)
      return LoanDateValidationError.required;

    // Start must be before end
    if (value.start!.isAfter(value.end!))
      return LoanDateValidationError.invalid;

    return null;
  }
}
