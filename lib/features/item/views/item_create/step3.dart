import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step3_tags/step3_bloc.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  TextEditingController? _textEditingController = TextEditingController();

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
        final bloc = Step3Bloc(context.read<CreateItemBloc>());
        bloc.add(const Step3InitialEvent());

        // TODO: debug only
        /*bloc.add(const NextStepEvent());*/
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
        body: BlocConsumer<Step3Bloc, Step3State>(
          listener: (context, state) {},
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
                              context.loc.item_tags_page_title,
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
                              context.loc.item_tags_page_description,
                              style: Theme.of(context).textTheme.labelSmall!,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.loc.item_tags_page_description_2,
                              style: Theme.of(context).textTheme.labelSmall!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Autocomplete<String>(
                        optionsBuilder:
                            (TextEditingValue textEditingValue) async {
                          // Begin the searching task
                          final task = context
                              .read<Step3Bloc>()
                              .suggestTags(textEditingValue.text);

                          // Create searching event so the bloc can handle the state
                          context.read<Step3Bloc>().add(SearchTagChanged(task));

                          // Wait for the result
                          final suggestedtags = await task;

                          // Return the result
                          return suggestedtags;
                        },
                        onSelected: (String selection) {
                          context.read<Step3Bloc>().add(AddTag(selection));
                          _textEditingController?.clear();
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          //_textEditingController = textEditingController;

                          return TextField(
                            controller: _textEditingController,
                            //controller: textEditingController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: context.loc.item_tags_title,
                              hintText: context.loc.item_tags_search_text,
                              //helperText: context.loc.item_tags_helper_text,
                              helperMaxLines: 2,
                              border: OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(10),
                              suffixIcon: state.isSuggesting
                                  ? IconButton(
                                      icon: SizedBox(
                                        height: 12,
                                        width: 12,
                                        child: CircularProgressIndicator(),
                                      ),
                                      onPressed: null,
                                    )
                                  : null,
                            ),
                            /*maxLines: 4,*/
                            textInputAction: TextInputAction.continueAction,
                            //onSubmitted: (String value) => onFieldSubmitted(),
                            onSubmitted: (String value) {
                              context.read<Step3Bloc>().add(AddTag(value));
                              _textEditingController?.clear();
                            },
                            onChanged: (String value) {
                              textEditingController.text = value;
                            },
                            /*  onChanged: (String value) => context
                                .read<Step3Bloc>()
                                .add(SearchTagChanged(value)),*/
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          spacing: 5,
                          children: state.selectedTags
                              .map((v) => Chip(
                                    label: Text(v),
                                    onDeleted: () => context
                                        .read<Step3Bloc>()
                                        .add(RemoveTag(v)),
                                  ))
                              // Sort the items based on their length
                              .toList()
                            ..sort((a, b) => b.label
                                .toString()
                                .length
                                .compareTo(a.label.toString().length)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: BlocBuilder<Step3Bloc, Step3State>(
            builder: (context, state) {
              return Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: Text(context.loc.back),
                    onPressed: () => context
                        .read<Step3Bloc>()
                        .add(const PreviousStepEvent()),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(context.loc.next),
                    onPressed: state.isValid
                        ? () =>
                            context.read<Step3Bloc>().add(const NextStepEvent())
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
