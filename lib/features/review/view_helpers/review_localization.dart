import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;
import 'package:pujcovadlo_client/features/review/models/comment.dart';

class ReviewLocalizationHelper {
  static String? commentError(AppLocalizations loc, ReviewComment model) {
    if (model.isPure || model.isValid) {
      return null;
    }

    switch (model.error) {
      case ReviewCommentValidationError.invalid:
        return loc.verror_input_invalid;
      case ReviewCommentValidationError.tooLong:
        return loc.verror_input_too_long;
      case null:
        return null;
    }
  }
}
