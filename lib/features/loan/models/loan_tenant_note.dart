import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum LoanTenantNoteValidationError {
  invalid,
  tooLong;

  const LoanTenantNoteValidationError();
}

class LoanTenantNote extends FormzInput<String, LoanTenantNoteValidationError> {
  const LoanTenantNote.pure([super.value = '']) : super.pure();

  const LoanTenantNote.dirty([super.value = '']) : super.dirty();

  static final _nameRegex = Regex.multilineTextRegex;
  static const int maxLength = 1000;

  @override
  LoanTenantNoteValidationError? validator(String value) {
    if (value.length > maxLength) return LoanTenantNoteValidationError.tooLong;

    // Check regex
    return _nameRegex.hasMatch(value)
        ? null
        : LoanTenantNoteValidationError.invalid;
  }
}
