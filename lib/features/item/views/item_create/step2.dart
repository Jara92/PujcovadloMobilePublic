import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step2_category_tags/step2_bloc.dart';

class Step2 extends StatelessWidget {
  const Step2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Step2Bloc(context.read<CreateItemBloc>()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.title_create_new_item),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            // Todo: ask confirmation if there are unsaved changes
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<Step2Bloc, Step2State>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              context.loc.item_categories_and_tags,
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
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.loc.item_categories_and_tags_description,
                              style: Theme.of(context).textTheme.labelSmall!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: BlocBuilder<Step2Bloc, Step2State>(
            builder: (context, state) {
              return Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: Text(context.loc.back),
                    onPressed: () => context
                        .read<Step2Bloc>()
                        .add(const PreviousStepEvent()),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(context.loc.next),
                    onPressed: state.isValid
                        ? () =>
                            context.read<Step2Bloc>().add(const NextStepEvent())
                        : null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
