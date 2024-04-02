part of 'create_review_bloc.dart';

@immutable
abstract class CreateReviewFormEvent {
  const CreateReviewFormEvent();
}

class InitialEvent extends CreateReviewFormEvent {
  const InitialEvent();
}

class RefreshCreateReviewFormEvent extends CreateReviewFormEvent {
  const RefreshCreateReviewFormEvent();
}

class RatingChangedEvent extends CreateReviewFormEvent {
  final double rating;

  const RatingChangedEvent(this.rating);
}

class CommentChangedEvent extends CreateReviewFormEvent {
  final String comment;

  const CommentChangedEvent(this.comment);
}

class SubmitCreateReviewFormEvent extends CreateReviewFormEvent {
  const SubmitCreateReviewFormEvent();
}
