import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/constants/routes.dart';
import 'package:pujcovadlo_client/core/custom_colors.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/summary/summary_bloc.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';
import 'package:pujcovadlo_client/features/item/views/item_create_view.dart';
import 'package:pujcovadlo_client/features/item/views/item_detail_view.dart';
import 'package:pujcovadlo_client/features/item/views/my_item_list.dart';

class Summary extends StatefulWidget {
  final ItemRequest item;

  const Summary({required this.item, super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = SummaryBloc(widget.item);
        bloc.add(const SummaryInitialEvent());
        return bloc;
      },
      child: Scaffold(
        body: BlocBuilder<SummaryBloc, SummaryState>(
          builder: (context, state) {
            var children = <Widget>[];

            if (state is IsProcessing) {
              children = _buildProcessing(context, state);
            }

            if (state is ErrorState) {
              children = _buildError(context, state);
            }

            if (state is SuccessState) {
              children = _buildSuccess(context, state);
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
      Text(context.loc.item_saving_failed,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              )),
      const SizedBox(height: 10),
      Text(
        context.loc.item_saving_failed_message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium!,
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () =>
                context.read<SummaryBloc>().add(const TryAgainEvent()),
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

  List<Widget> _buildProcessing(BuildContext context, IsProcessing state) {
    return [
      CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 15),
      Text(context.loc.item_saving_processing,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              )),
      const SizedBox(height: 10),
      Text(
        context.loc.item_saving_processing_message,
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
      Text(context.loc.item_saving_success,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              )),
      const SizedBox(height: 10),
      Text(
        context.loc.item_saving_success_message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium!,
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Go back to root so the use cannot go back to the summary page
              Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));

              // Open create item page
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ItemDetailView(itemId: state.response.id)));
            },
            icon: const Icon(Icons.visibility),
            label: Text(context.loc.item_saving_success_show_detail),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              // Go back to root so the use cannot go back to the summary page
              Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));

              // Open my items
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MyItemList()),
              );
            },
            icon: const Icon(Icons.list),
            label: Text(context.loc.item_saving_success_show_my_items),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              // Go back to root so the use cannot go back to the summary page
              Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));

              // Open create item page
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ItemCreateView()),
              );
            },
            icon: const Icon(Icons.add),
            label: Text(context.loc.item_saving_success_add_another),
          ),
        ],
      )
    ];
  }
}
