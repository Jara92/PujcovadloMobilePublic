import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/core/widgets/loading_indicator.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/loan/bloc/lent_detail/lent_loan_detail_bloc.dart';
import 'package:pujcovadlo_client/features/loan/enums/loan_status.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/view_helpers/loan_status.dart';
import 'package:pujcovadlo_client/features/loan/widgets/loan_item_preview.dart';
import 'package:pujcovadlo_client/features/loan/widgets/loan_status_badge.dart';
import 'package:pujcovadlo_client/features/profiles/widgets/profile_widget.dart';

class LentLoanDetailView extends StatefulWidget {
  final int? loanId;
  final LoanResponse? loan;

  const LentLoanDetailView({this.loanId, this.loan, super.key})
      : assert(loanId != null || loan != null);

  @override
  State<LentLoanDetailView> createState() => _LentLoanDetailViewState();
}

class _LentLoanDetailViewState extends State<LentLoanDetailView> {
  late final LentLoanDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LentLoanDetailBloc(loan: widget.loan, loanId: widget.loanId)
      ..add(InitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: LoaderOverlay(
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.loc.loan_lent_detail_page_title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return RefreshIndicator(
                onRefresh: () =>
                    Future.sync(() => _bloc.add(RefreshLentLoanDetailEvent())),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: BlocConsumer<LentLoanDetailBloc, LentLoanDetailState>(
                    listener: (context, state) {
                      // Show loader overlay when the state is busy
                      if (state.isBusy) {
                        context.loaderOverlay.show();
                      } else {
                        context.loaderOverlay.hide();
                      }

                      if (state.actionError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(context.loc.loan_action_error),
                        ));

                        // Clear the error
                        BlocProvider.of<LentLoanDetailBloc>(context)
                            .add(ClearActionErrorEvent());
                      }
                    },
                    builder: (context, state) {
                      // Loan detail is loaded
                      if (state.status == LentLoanDetailStateEnum.loaded) {
                        return _buildLoanDetail(context, state);
                      }

                      // something failed
                      if (state.status == LentLoanDetailStateEnum.error) {
                        return OperationError(
                            minHeight: viewportConstraints.maxHeight,
                            onRetry: () =>
                                BlocProvider.of<LentLoanDetailBloc>(context)
                                    .add(RefreshLentLoanDetailEvent()));
                      }

                      return LoadingIndicator(
                        minHeight: viewportConstraints.maxHeight,
                      );
                    },
                  ),
                ),
              );
            }),
          ),
          bottomNavigationBar: const MainBottomNavigationBar(),
        ),
      ),
    );
  }

  Future<void> _markLoanAsActive(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.loc.loan_marking_as_active_title),
          content: Text(context.loc.loan_marking_as_active_message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.loc.loan_marking_as_active_cancel_button),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.loc.loan_marking_as_active_confirm_button),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        _bloc.add(UpdateLoanStatusEvent(LoanStatus.active));
      }
    });
  }

  Future<void> _markLoanAsReturned(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.loc.loan_marking_as_returned_title),
          content: Text(context.loc.loan_marking_as_returned_message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.loc.loan_marking_as_returned_cancel_button),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.loc.loan_marking_as_returned_confirm_button),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        _bloc.add(UpdateLoanStatusEvent(LoanStatus.returned));
      }
    });
  }

  Widget _buildLoanDetail(BuildContext context, LentLoanDetailState state) {
    final loan = state.loan!;

    return Column(
      children: [
        Row(
          children: [
            Text(
              context.loc.loan_lent_subject,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ],
        ),
        const SizedBox(height: 10),
        LoanItemPreview(
            loan: loan,
            statusBadge: LoanStatusBadge(
              title: LoanStatusLocalizationHelper.locForOwner(
                  context, loan.status),
            )),
        const SizedBox(height: 5),
        if (loan.tenantNote != null)
          Row(
            children: [
              Expanded(
                  child: Text.rich(TextSpan(
                children: [
                  TextSpan(
                    text: context.loc.loan_tenant_note_short,
                    style: Theme.of(context).textTheme.labelSmall!,
                  ),
                  TextSpan(
                    text: loan.tenantNote!,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ))),
            ],
          ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                "${context.loc.loan_lent_is_in_status} ${LoanStatusLocalizationHelper.locForOwner(context, loan.status)}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                LoanStatusLocalizationHelper.locDescriptionForOwner(
                    context, loan.status),
                style: Theme.of(context).textTheme.labelSmall!,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ..._buildContextButtons(context, loan),
        const SizedBox(height: 20),
        const Divider(),
        Row(
          children: [
            Text(
              context.loc.loan_tenant_profile_title,
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ],
        ),
        const SizedBox(height: 5),
        ProfileWidget(user: loan.tenant),
      ],
    );
  }

  List<Widget> _buildContextButtons(BuildContext context, LoanResponse loan) {
    final buttons = <Widget>[];

    switch (loan.status) {
      case LoanStatus.inquired:
        // Approve button
        buttons.add(ElevatedButton.icon(
          icon: const Icon(Icons.check),
          onPressed: () {
            _bloc.add(UpdateLoanStatusEvent(LoanStatus.accepted));
          },
          label: Text(context.loc.loan_approve_button),
        ));

        // Deny button
        buttons.add(OutlinedButton.icon(
          icon: const Icon(Icons.close),
          onPressed: () {
            _bloc.add(UpdateLoanStatusEvent(LoanStatus.denied));
          },
          label: Text(context.loc.loan_deny_button),
        ));
        break;

      case LoanStatus.denied:
        buttons.add(_buildCreateReviewButton(context));
        break;

      case LoanStatus.accepted:
        // Mark as active button
        buttons.add(ElevatedButton.icon(
            icon: const Icon(Icons.check),
            onPressed: () {
              _markLoanAsActive(context);
            },
            label: Text(context.loc.loan_mark_as_active_button)));

        // Cancel button
        buttons.add(_buildCancelButton(context));
        break;

      // todo: add remaining cases
      // case LoanStatus.preparedForPickup: break;
      // case LoanStatus.pickupDenied: break;

      case LoanStatus.active:
        // Mark as returned
        buttons.add(ElevatedButton.icon(
            icon: const Icon(Icons.check),
            onPressed: () {
              _markLoanAsReturned(context);
            },
            label: Text(context.loc.loan_mark_as_returned_button)));
        break;

      // todo: add remaining cases
      // case LoanStatus.preparedForReturn: break;
      // case LoanStatus.returnDenied: break;

      case LoanStatus.returned:
        // Create review button
        buttons.add(_buildCreateReviewButton(context));
        break;

      // todo: add remaining cases
      default:
        break;
    }

    return buttons;
  }

  Widget _buildCancelButton(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.cancel),
      onPressed: () {
        _bloc.add(UpdateLoanStatusEvent(LoanStatus.cancelled));
      },
      label: Text(context.loc.loan_cancel_button),
    );
  }

  Widget _buildCreateReviewButton(BuildContext context) {
    return ElevatedButton.icon(
        icon: const Icon(Icons.star),
        onPressed: () {
          // todo
        },
        label: Text(context.loc.loan_create_review_button));
  }
}
