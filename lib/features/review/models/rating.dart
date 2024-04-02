import 'package:formz/formz.dart';

enum ReviewRatingValidationError {
  required,
  tooSmall,
  tooLarge;

  const ReviewRatingValidationError();
}

class ReviewRating extends FormzInput<double?, ReviewRatingValidationError> {
  const ReviewRating.pure([super.value]) : super.pure();

  const ReviewRating.dirty([super.value]) : super.dirty();

  static const minValue = 0;
  static const maxValue = 5;

  @override
  ReviewRatingValidationError? validator(double? value) {
    if (value == null) return ReviewRatingValidationError.required;

    if (value < minValue) return ReviewRatingValidationError.tooSmall;
    if (value > maxValue) return ReviewRatingValidationError.tooLarge;

    return null;
  }
}
