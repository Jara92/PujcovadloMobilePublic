import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/constants/routes.dart';
import 'package:pujcovadlo_client/core/custom_colors.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/loan/bloc/create_loan/submit/submit_bloc.dart';
import 'package:pujcovadlo_client/features/loan/requests/loan_request.dart';
import 'package:pujcovadlo_client/features/loan/views/borrowed_detail_view.dart';

class CreateLoanSubmitView extends StatefulWidget {
  final LoanRequest loan;

  const CreateLoanSubmitView({required this.loan, super.key});

  @override
  State<CreateLoanSubmitView> createState() => _CreateLoanSubmitViewState();
}

class _CreateLoanSubmitViewState extends State<CreateLoanSubmitView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CreateLoanSubmitBloc(widget.loan);
        bloc.add(const CreateLoanSubmitInitialEvent());
        return bloc;
      },
      child: Scaffold(
        body: BlocBuilder<CreateLoanSubmitBloc, CreateLoanSubmitState>(
          builder: (context, state) {
            var children = <Widget>[];

            // Still processing
            if (state.status == CreateLoanSubmitEventEnum.processing) {
              children = _buildProcessing(context, state);
            }

            // Error occurred
            if (state.status == CreateLoanSubmitEventEnum.error) {
              children = _buildError(context, state as ErrorState);
            }

            // Success
            if (state.status == CreateLoanSubmitEventEnum.success) {
              children = _buildSuccess(context, state as SuccessState);
            }

            return PopScope(
              canPop: false,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  )),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildError(BuildContext context, ErrorState state) {
    return [
      Icon(
        Icons.error,
        size: 100,
        color: Theme.of(context).colorScheme.error,
      ),
      const SizedBox(height: 5),
      Text(context.loc.loan_saving_failed,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              )),
      const SizedBox(height: 10),
      Text(
        context.loc.loan_saving_failed_message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium!,
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () =>
                context.read<CreateLoanSubmitBloc>().add(const TryAgainEvent()),
            icon: const Icon(Icons.refresh),
            label: Text(context.loc.item_saving_failed_try_again),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: Text(context.loc.item_saving_failed_go_back),
          ),
        ],
      )
    ];
  }

  List<Widget> _buildProcessing(
      BuildContext context, CreateLoanSubmitState state) {
    return [
      CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 15),
      Text(context.loc.loan_saving_processing,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              )),
      const SizedBox(height: 10),
      Text(
        context.loc.loan_saving_processing_message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium!,
      ),
    ];
  }

  List<Widget> _buildSuccess(BuildContext context, SuccessState state) {
    return [
      const Icon(
        Icons.check_circle,
        size: 100,
        color: CustomColors.success,
      ),
      const SizedBox(height: 5),
      Text(context.loc.loan_saved_success,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              )),
      const SizedBox(height: 10),
      Text(
        context.loc.loan_saved_success_message,
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
              Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));
            },
            icon: const Icon(Icons.search),
            label: Text(context.loc.loan_saved_back_to_searching_button),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Go back to root so the use cannot go back to the summary page
              Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));

              // Redirect to loan detail
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BorrowedLoanDetailView(
                      loanId: state.loanId, loan: state.loan)));
            },
            icon: const Icon(Icons.visibility),
            label: Text(context.loc.loan_saved_show_new_reservation_button),
          ),
        ],
      ),
    ];
  }
}
