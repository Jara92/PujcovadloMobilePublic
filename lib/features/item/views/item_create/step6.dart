import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/preview/preview_bloc.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/form_container.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/preview_widget.dart';

class Step6 extends StatefulWidget {
  const Step6({super.key});

  @override
  State<Step6> createState() => _Step6State();
}

class _Step6State extends State<Step6> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = PreviewBloc(context.read<CreateItemBloc>());
        //bloc.add(const PreviewInitialEvent());
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.title_create_new_item),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            // Todo: ask confirmation if there are unsaved changes
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocListener<CreateItemBloc, CreateItemState>(
          listener: (context, state) {
            context.read<PreviewBloc>().add(const PreviewUpdate());
          },
          child: BlocBuilder<PreviewBloc, PreviewState>(
            builder: (context, state) {
              return FormContainer(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.info_outline,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            context.loc.item_preview_page_title,
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
                            context.loc.item_preview_page_description,
                            style: Theme.of(context).textTheme.labelSmall!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (state.data != null)
                      ItemPreviewWidget(item: state.data!),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: BlocBuilder<PreviewBloc, PreviewState>(
            builder: (context, state) {
              return Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: Text(context.loc.back),
                    onPressed: () => context
                        .read<PreviewBloc>()
                        .add(const PreviousStepEvent()),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: Text(context.loc.publish),
                    onPressed: state.isValid
                        ? () => context
                            .read<PreviewBloc>()
                            .add(const NextStepEvent())
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
