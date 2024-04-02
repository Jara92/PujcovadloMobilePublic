import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';

enum ReviewCommentValidationError {
  invalid,
  tooLong;

  const ReviewCommentValidationError();
}

class ReviewComment extends FormzInput<String, ReviewCommentValidationError> {
  const ReviewComment.pure([super.value = '']) : super.pure();

  const ReviewComment.dirty([super.value = '']) : super.dirty();

  static final _commentRegex = Regex.multilineTextRegex;
  static const int maxLength = 1000;

  @override
  ReviewCommentValidationError? validator(String value) {
    if (value.length > maxLength) return ReviewCommentValidationError.tooLong;

    // Check regex
    return _commentRegex.hasMatch(value)
        ? null
        : ReviewCommentValidationError.invalid;
  }
}
