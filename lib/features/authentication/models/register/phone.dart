import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum RegisterPhoneValidationError { required, invalid }

class RegisterPhone extends FormzInput<String, RegisterPhoneValidationError> {
  const RegisterPhone.pure() : super.pure('');

  const RegisterPhone.dirty([super.value = '']) : super.dirty();

  static final RegExp _phoneRegex = Regex.phoneNumberRegex;

  //static const int minLength = 9;
  static const int maxLength = 17;

  @override
  RegisterPhoneValidationError? validator(String value) {
    // Phone number is not required
    if (value.isEmpty) return null;

    // Length is validated using the regex

    final reg = RegExp(r'(^([+][0-9]{3})?[0-9]{9}$)');

    // Must contain only letters
    return reg.hasMatch(value) ? null : RegisterPhoneValidationError.invalid;
  }
}
