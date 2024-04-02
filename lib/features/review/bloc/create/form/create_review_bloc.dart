import 'dart:async';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/services/loan_service.dart';
import 'package:pujcovadlo_client/features/review/models/comment.dart';
import 'package:pujcovadlo_client/features/review/models/rating.dart';
import 'package:pujcovadlo_client/features/review/requests/review_request.dart';
import 'package:pujcovadlo_client/features/review/services/review_service.dart';

part 'create_review_event.dart';
part 'create_review_state.dart';

class CreateReviewFormBloc
    extends Bloc<CreateReviewFormEvent, CreateReviewFormState> {
  final LoanService _loanService = GetIt.instance.get<LoanService>();
  final ReviewService _reviewService = GetIt.instance.get<ReviewService>();

  int? loanId;
  LoanResponse? loan;

  CreateReviewFormBloc({this.loanId, this.loan})
      : assert(loanId != null || loan != null),
        super(CreateReviewFormState.initial()) {
    on<InitialEvent>(_onInitialEvent);
    on<RefreshCreateReviewFormEvent>(_onRefreshLoanDetail);
    on<RatingChangedEvent>(_onRatingChanged);
    on<CommentChangedEvent>(_onCommentChangedEvent);
    on<SubmitCreateReviewFormEvent>(_onSubmitCreateReviewFormEvent);
  }

  Future<void> _onInitialEvent(
      InitialEvent event, Emitter<CreateReviewFormState> emit) async {
    // Load the loan detail if it is not provided directly
    if (loan == null) {
      return _loadLoanDetail(emit);
    }

    // Set the loan id if it is not provided directly
    loanId = loan!.id;

    // Emit loaded state if the loan is provided directly
    emit(state.copyWith(status: CreateReviewFormStateEnum.loaded, loan: loan!));
  }

  Future<void> _loadLoanDetail(Emitter<CreateReviewFormState> emit) async {
    // Emit loading state
    emit(state.copyWith(status: CreateReviewFormStateEnum.loading));

    try {
      // Loan loan by id
      loan = await _loanService.getLoanById(loanId!);

      // Emit loaded state
      emit(state.copyWith(
        status: CreateReviewFormStateEnum.loaded,
        loan: loan,
      ));
    }
    // Emit failed state if an exception was thrown
    on Exception catch (e) {
      emit(state.copyWith(
        status: CreateReviewFormStateEnum.error,
        error: () => e,
      ));
    }
  }

  Future<void> _onRefreshLoanDetail(RefreshCreateReviewFormEvent event,
      Emitter<CreateReviewFormState> emit) async {
    // Refresh the page by loading the loan again
    return _loadLoanDetail(emit);
  }

  Future<void> _onRatingChanged(
      RatingChangedEvent event, Emitter<CreateReviewFormState> emit) async {
    // Validate new dates
    final newRating = ReviewRating.dirty(event.rating);

    // Update bloc state
    emit(state.copyWith(
      rating: newRating,
    ));
  }

  Future<void> _onCommentChangedEvent(
      CommentChangedEvent event, Emitter<CreateReviewFormState> emit) async {
    // Update tenant note
    final newComment = ReviewComment.dirty(event.comment);

    // Update bloc state
    emit(state.copyWith(
      comment: newComment,
    ));
  }

  Future<void> _onSubmitCreateReviewFormEvent(SubmitCreateReviewFormEvent event,
      Emitter<CreateReviewFormState> emit) async {
    // Validate the form
    if (!state.isValid) {
      return;
    }

    // Emit loading state
    emit(state.copyWith(submissionStatus: FormzSubmissionStatus.inProgress));

    try {
      // Create review
      final review = await _reviewService.createReview(ReviewRequest(
        loanId: loanId,
        comment: state.comment.value,
        rating: state.rating.value,
      ));

      // Add new review to the loan
      loan!.reviews.add(review);

      // Emit success state
      emit(state.copyWith(submissionStatus: FormzSubmissionStatus.success));
    }
    // Emit failed state if an exception was thrown
    on Exception catch (e) {
      emit(state.copyWith(
        submissionStatus: FormzSubmissionStatus.failure,
        error: () => e,
      ));
    }
  }
}
