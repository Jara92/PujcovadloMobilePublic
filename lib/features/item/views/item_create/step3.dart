import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step3_tags/step3_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  String? _localizeTagError(BuildContext context, ItemTag tag) {
    if (tag.isPure || tag.isValid) {
      return null;
    }

    switch (tag.error) {
      case ItemTagValidationError.invalid:
        return context.loc.item_tags_verror_tag_format_is_invalid;
      case ItemTagValidationError.tooShort:
        return context.loc.item_tags_verror_tag_is_too_short;
      case ItemTagValidationError.tooLong:
        return context.loc.item_tags_verror_tag_is_too_long;
      case null:
        return null;
    }
  }

  String? _localizeTagsError(BuildContext context, ItemTags tags) {
    if (tags.isPure || tags.isValid) {
      return null;
    }

    switch (tags.error) {
      case ItemTagsValidationError.invalid:
        return context.loc.item_tags_verror_tag_format_is_invalid;
      case ItemTagsValidationError.tooManyTags:
        return context.loc.item_tags_verror_too_many_tags;
      case ItemTagsValidationError.notEnoughTags:
        return context.loc.item_tags_verror_not_enough_tags;
      case null:
        return null;
    }
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
          listener: (context, state) {
            _textEditingController.text = state.currentTag.value;
          },
          builder: (context, state) {
            return PopScope(
              canPop: false,
              child: SafeArea(
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
                        const SizedBox(
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
                        Row(children: [
                          Text(
                              _localizeTagError(context, state.currentTag) ??
                                  _localizeTagsError(
                                      context, state.selectedTags) ??
                                  '',
                              textAlign: TextAlign.left,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ))
                        ]),
                        const SizedBox(height: 10),
                        Autocomplete<String>(
                          optionsBuilder:
                              (TextEditingValue textEditingValue) async {
                            // Begin the searching task
                            final task = context
                                .read<Step3Bloc>()
                                .suggestTags(textEditingValue.text);

                            // Create searching event so the bloc can handle the state
                            context.read<Step3Bloc>().add(
                                SearchTagChanged(textEditingValue.text, task));

                            // Wait for the result
                            final suggestedtags = await task;

                            // Return the result
                            return suggestedtags;
                          },
                          onSelected: (String selection) {
                            context
                                .read<Step3Bloc>()
                                .add(SelectSuggestion(selection));
                          },
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted) {
                            return SearchBar(
                              controller: _textEditingController,
                              focusNode: focusNode,
                              leading: const Icon(Icons.tag),
                              trailing: <Widget>[
                                if (state.isSuggesting)
                                  const SizedBox(
                                    height: 12,
                                    width: 12,
                                    child: CircularProgressIndicator(),
                                  ),
                                Tooltip(
                                  message: context
                                      .loc.item_categories_search_tooltip,
                                  child: IconButton(
                                    isSelected: false,
                                    onPressed: () {
                                      _textEditingController.clear();
                                      textEditingController.clear();
                                    },
                                    icon: const Icon(Icons.clear),
                                    selectedIcon:
                                        const Icon(Icons.manage_search),
                                  ),
                                )
                              ],
                              textInputAction: TextInputAction.continueAction,
                              padding:
                                  const MaterialStatePropertyAll<EdgeInsets>(
                                      EdgeInsets.symmetric(horizontal: 16.0)),
                              onSubmitted: (String value) {
                                context.read<Step3Bloc>().add(AddTag(value));
                                _textEditingController.clear();
                              },
                              onChanged: (String value) {
                                textEditingController.text = value;
                              },
                              hintText: context.loc.item_tags_search_text,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              textAlign: TextAlign.left,
                              context.loc.item_selected_tags_remaining_count(
                                  state.selectedTags.value.length,
                                  ItemTags.maxTagsCount),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            spacing: 5,
                            children: state.selectedTags.value
                                .map((v) => Chip(
                                      padding: const EdgeInsets.all(2),
                                      label: Text(
                                        v,
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      onDeleted: () => context
                                          .read<Step3Bloc>()
                                          .add(RemoveTag(v)),
                                    ))
                                .toList(),
                          ),
                        )
                      ],
                    ),
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
