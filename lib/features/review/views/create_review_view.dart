import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:formz/formz.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pujcovadlo_client/core/constants/regex.dart';
import 'package:pujcovadlo_client/core/custom_colors.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/core/widgets/loading_indicator.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/widgets/loan_item_preview.dart';
import 'package:pujcovadlo_client/features/review/bloc/create/form/create_review_bloc.dart';
import 'package:pujcovadlo_client/features/review/view_helpers/review_localization.dart';

class CreateReviewView extends StatefulWidget {
  final int? loanId;
  final LoanResponse? loan;

  const CreateReviewView({this.loanId, this.loan, super.key})
      : assert(loanId != null || loan != null);

  @override
  State<CreateReviewView> createState() => _CreateReviewViewState();
}

class _CreateReviewViewState extends State<CreateReviewView> {
  late final CreateReviewFormBloc _bloc;
  late final TextEditingController _controllerComment;

  @override
  void initState() {
    super.initState();
    _bloc = CreateReviewFormBloc(loan: widget.loan, loanId: widget.loanId)
      ..add(const InitialEvent());
    _controllerComment = TextEditingController();
  }

  @override
  void dispose() {
    _controllerComment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
          appBar: AppBar(
            title: Text(context.loc.review_create_page_title),
          ),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: BlocConsumer<CreateReviewFormBloc,
                        CreateReviewFormState>(
                      listenWhen: (previous, current) =>
                          previous.submissionStatus != current.submissionStatus,
                      listener: (context, state) {
                        if (state.submissionStatus ==
                            FormzSubmissionStatus.inProgress) {
                          context.loaderOverlay.show();
                        } else {
                          context.loaderOverlay.hide();
                        }

                        // Display error message
                        if (state.submissionStatus ==
                            FormzSubmissionStatus.failure) {
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(SnackBar(
                              content: Text(context.loc.review_saved_error),
                              /*action: SnackBarAction(
                              label: context.loc.retry,
                              onPressed: () => _bloc.add(
                                const SubmitCreateReviewFormEvent(),
                              ),
                            ),*/
                            ));
                        }
                      },
                      builder: (context, state) {
                        if (state.submissionStatus ==
                            FormzSubmissionStatus.success) {
                          return _SuccessView(loan: state.loan!);
                        }

                        // Review detail is loaded
                        if (state.status == CreateReviewFormStateEnum.loaded) {
                          return _buildForm(context, state);
                        }

                        // something failed
                        if (state.status == CreateReviewFormStateEnum.error) {
                          return OperationError(
                              onRetry: () => BlocProvider.of<
                                      CreateReviewFormBloc>(context)
                                  .add(const RefreshCreateReviewFormEvent()));
                        }

                        return LoadingIndicator();
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar:
              BlocBuilder<CreateReviewFormBloc, CreateReviewFormState>(
            builder: (context, state) {
              return state.submissionStatus != FormzSubmissionStatus.success
                  ? BottomAppBar(
                      child: Row(
                        children: [
                          const Spacer(),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.send),
                            label: Text(context.loc.loan_sent_button),
                            // Allow to go to the next step only if the form is valid
                            onPressed: state.isValid
                                ? () => BlocProvider.of<CreateReviewFormBloc>(
                                        context)
                                    .add(const SubmitCreateReviewFormEvent())
                                : null,
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink();
            },
          )),
    );
  }

  Widget _buildForm(BuildContext context, CreateReviewFormState state) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              context.loc.review_create_subject,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ],
        ),
        const SizedBox(height: 10),
        LoanItemPreview(
          loan: state.loan!,
        ),
        const SizedBox(height: 20),
/*        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.loc.review_rating_title,
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ],
        ),
        const SizedBox(height: 10),*/
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: 3,
              itemCount: 5,
              itemSize: 50,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  // Should never happen
                  default:
                    return const SizedBox.shrink();
                }
              },
              onRatingUpdate: (rating) =>
                  BlocProvider.of<CreateReviewFormBloc>(context)
                      .add(RatingChangedEvent(rating)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controllerComment,
                onChanged: (String value) =>
                    BlocProvider.of<CreateReviewFormBloc>(context)
                        .add(CommentChangedEvent(value)),
                maxLength: 500,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(Regex.multilineTextRegex),
                ],
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                // Set this
                maxLines: 7,
                enableSuggestions: true,
                decoration: InputDecoration(
                  labelText: context.loc.review_comment_title,
                  hintText: context.loc.review_comment_hint,
                  helperText: context.loc.review_comment_helper,
                  helperMaxLines: 3,
                  errorText: ReviewLocalizationHelper.commentError(
                      context.loc, state.comment),
                  border: const OutlineInputBorder(),
                  //border: InputBorder.none
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final LoanResponse loan;

  const _SuccessView({required this.loan, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            size: 100,
            color: CustomColors.success,
          ),
          const SizedBox(height: 5),
          Text(context.loc.review_saved_success,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 10),
          Text(
            context.loc.review_saved_success_message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Go back to root so the use cannot go back to the summary page
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.home),
                label: Text(context.loc.review_saved_back_button),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
