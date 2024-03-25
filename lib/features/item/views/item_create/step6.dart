import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/preview/preview_bloc.dart';
import 'package:pujcovadlo_client/features/item/views/item_create/summary.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/form_container.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/item_form_heading.dart';
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
      create: (context) => PreviewBloc(context.read<CreateItemBloc>()),
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
                    ItemFormHeading(
                      title: context.loc.item_preview_page_title,
                      description: context.loc.item_preview_page_description,
                    ),
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
                    onPressed: () => state.data != null
                        ? Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Summary(item: state.data!),
                            ),
                          )
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
