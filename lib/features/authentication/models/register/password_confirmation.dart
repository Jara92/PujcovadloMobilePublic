import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/features/authentication/models/register/password.dart';

enum RegisterPasswordConfirmationValidationError { required, mismatch }

class RegisterPasswordConfirmation
    extends FormzInput<String, RegisterPasswordConfirmationValidationError> {
  const RegisterPasswordConfirmation.pure()
      : original = const RegisterPassword.pure(),
        super.pure('');

  const RegisterPasswordConfirmation.dirty(
      {required this.original, String value = ""})
      : super.dirty(value);

  final RegisterPassword original;

  @override
  RegisterPasswordConfirmationValidationError? validator(String value) {
    // Error when the value is not the same as the original password
    if (value != original.value) {
      return RegisterPasswordConfirmationValidationError.mismatch;
    }

    return null;
  }
}
