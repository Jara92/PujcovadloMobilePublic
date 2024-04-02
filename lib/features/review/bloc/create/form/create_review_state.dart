part of 'create_review_bloc.dart';

enum CreateReviewFormStateEnum { initial, loading, loaded, error }

@immutable
class CreateReviewFormState {
  final CreateReviewFormStateEnum status;
  final FormzSubmissionStatus submissionStatus;
  final Exception? error;

  final ReviewRating rating;
  final ReviewComment comment;

  final LoanResponse? loan;

  /// Is the form valid?
  bool get isValid => rating.isValid && comment.isValid;

  const CreateReviewFormState({
    required this.status,
    required this.submissionStatus,
    this.error,
    this.rating = const ReviewRating.pure(),
    this.comment = const ReviewComment.pure(),
    this.loan,
  });

  CreateReviewFormState copyWith({
    CreateReviewFormStateEnum? status,
    FormzSubmissionStatus? submissionStatus,
    Exception? Function()? error,
    ReviewRating? rating,
    ReviewComment? comment,
    LoanResponse? loan,
  }) {
    return CreateReviewFormState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      error: error != null ? error() : this.error,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      loan: loan ?? this.loan,
    );
  }

  factory CreateReviewFormState.initial() {
    return const CreateReviewFormState(
      status: CreateReviewFormStateEnum.initial,
      submissionStatus: FormzSubmissionStatus.initial,
      rating: ReviewRating.pure(),
      comment: ReviewComment.pure(),
    );
  }
}
