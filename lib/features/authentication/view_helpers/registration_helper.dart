import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;
import 'package:pujcovadlo_client/features/authentication/models/register/models.dart';

class RegistrationLocalizationHelper {
  static String? firstNameError(AppLocalizations loc, FirstName model) {
    if (model.isPure || model.isValid) {
      return null;
    }

    switch (model.error) {
      case FirstNameValidationError.required:
        return loc.verror_this_field_is_required;
      case FirstNameValidationError.invalid:
        return loc.verror_input_invalid;
      case null:
        return null;
      case FirstNameValidationError.tooShort:
        return loc.verror_input_too_short;
      case FirstNameValidationError.tooLong:
        return loc.verror_input_too_long;
    }
  }

  static String? lastNameError(AppLocalizations loc, LastName model) {
    if (model.isPure || model.isValid) {
      return null;
    }

    switch (model.error) {
      case LastNameValidationError.required:
        return loc.verror_this_field_is_required;
      case LastNameValidationError.invalid:
        return loc.verror_input_invalid;
      case LastNameValidationError.tooShort:
        return loc.verror_input_too_short;
      case LastNameValidationError.tooLong:
        return loc.verror_input_too_long;
      case null:
        return null;
    }
  }

  static String? usernameError(AppLocalizations loc, RegisterUsername model) {
    if (model.isPure || model.isValid) {
      return null;
    }

    switch (model.error) {
      case RegisterUsernameValidationError.required:
        return loc.register_username_verror_required;
      case RegisterUsernameValidationError.invalid:
        return loc.register_username_verror_invalid;
      case RegisterUsernameValidationError.tooShort:
        return loc.register_username_verror_too_short;
      case RegisterUsernameValidationError.tooLong:
        return loc.register_username_verror_too_long;
      case null:
        return null;
    }
  }

  static String? emailError(AppLocalizations loc, RegisterEmail model) {
    if (model.isPure || model.isValid) {
      return null;
    }

    switch (model.error) {
      case RegisterEmailValidationError.required:
        return loc.verror_this_field_is_required;
      case RegisterEmailValidationError.invalid:
        return loc.register_email_verror_invalid;
      case RegisterEmailValidationError.tooLong:
        return loc.verror_input_too_long;
      case null:
        return null;
    }
  }

  static String? phoneError(AppLocalizations loc, RegisterPhone model) {
    if (model.isPure || model.isValid) {
      return null;
    }

    switch (model.error) {
      case RegisterPhoneValidationError.required:
        return loc.verror_this_field_is_required;
      case RegisterPhoneValidationError.invalid:
        return loc.register_phone_verror_invalid;
      case null:
        return null;
    }
  }

  static String? passwordError(AppLocalizations loc, RegisterPassword model) {
    if (model.isPure || model.isValid) {
      return null;
    }

    switch (model.error) {
      case RegisterPasswordValidationError.required:
        return loc.verror_this_field_is_required;
      case RegisterPasswordValidationError.invalid:
        return loc.verror_input_invalid;
      case RegisterPasswordValidationError.tooShort:
        return loc.register_password_verror_too_short;
      case RegisterPasswordValidationError.weak:
        return loc.register_password_verror_weak;
      case null:
        return null;
    }
  }

  static String? passwordConfirmationError(
      AppLocalizations loc, RegisterPasswordConfirmation model) {
    if (model.isPure || model.isValid) {
      return null;
    }

    switch (model.error) {
      case RegisterPasswordConfirmationValidationError.required:
        return loc.verror_this_field_is_required;
      case RegisterPasswordConfirmationValidationError.mismatch:
        return loc.register_password_confirmation_verror_mismatch;
      case null:
        return null;
    }
  }
}
