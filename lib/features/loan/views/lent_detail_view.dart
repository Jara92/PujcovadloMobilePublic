import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/core/widgets/main_bottom_navigation_bar.dart';
import 'package:pujcovadlo_client/features/loan/bloc/lent_detail/lent_loan_detail_bloc.dart';
import 'package:pujcovadlo_client/features/loan/responses/loan_response.dart';
import 'package:pujcovadlo_client/features/loan/view_helpers/loan_status.dart';
import 'package:pujcovadlo_client/features/loan/widgets/loan_item_preview.dart';
import 'package:pujcovadlo_client/features/loan/widgets/loan_status_badge.dart';

class LentLoanDetailView extends StatefulWidget {
  final int? loanId;
  final LoanResponse? loan;

  const LentLoanDetailView({this.loanId, this.loan, super.key})
      : assert(loanId != null || loan != null);

  @override
  State<LentLoanDetailView> createState() => _LentLoanDetailViewState();
}

class _LentLoanDetailViewState extends State<LentLoanDetailView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LentLoanDetailBloc(loan: widget.loan, loanId: widget.loanId)
            ..add(LoadLentLoanDetail()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.loan_lent_detail_page_title),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<LentLoanDetailBloc>(context)
                .add(RefreshLentLoanDetailEvent());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: BlocConsumer<LentLoanDetailBloc, LentLoanDetailState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is LentLoanDetailLoaded) {
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
                            loan: state.loan,
                            statusBadge: LoanStatusBadge(
                              title: LoanStatusLocalizationHelper.locForOwner(
                                  context, state.loan.status),
                            )),
                        const SizedBox(height: 5),
                        if (state.loan.tenantNote != null)
                          Row(
                            children: [
                              Expanded(
                                  child: Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                    text: context.loc.loan_tenant_note_short,
                                    style:
                                        Theme.of(context).textTheme.labelSmall!,
                                  ),
                                  TextSpan(
                                    text: state.loan.tenantNote!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
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
                            Icon(Icons.info_outline,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "${context.loc.loan_lent_is_in_status} ${LoanStatusLocalizationHelper.locForOwner(context, state.loan.status)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
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
                                LoanStatusLocalizationHelper
                                    .locDescriptionForOwner(
                                        context, state.loan.status),
                                style: Theme.of(context).textTheme.labelSmall!,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  // something failed
                  if (state is LentLoanDetailFailed) {
                    return OperationError(
                        onRetry: () =>
                            BlocProvider.of<LentLoanDetailBloc>(context)
                                .add(RefreshLentLoanDetailEvent()));
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: const MainBottomNavigationBar(),
      ),
    );
  }
}
