import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/helpers/debouncer.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step3_tags/step3_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/form_container.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/item_form_heading.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  late final TextEditingController _textEditingController;
  late final DebounceableFunction<List<String>, String> _debouncedSearch;
  late final Step3Bloc _bloc;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _bloc = Step3Bloc(context.read<CreateItemBloc>())
      ..add(const Step3InitialEvent());
    _debouncedSearch = DebounceableFunction<List<String>, String>(
        _search, const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _debouncedSearch.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
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
            // Update controllers value only when the value is different
            // This is to prevent the cursor from moving to the end of the text
            if (_textEditingController.text != state.currentTag.value) {
              _textEditingController.text = state.currentTag.value;
            }
          },
          builder: (context, state) {
            return FormContainer(
              child: Column(
                children: [
                  ItemFormHeading(
                    title: context.loc.item_tags_page_title,
                    description: context.loc.item_tags_page_description,
                    bottomMargin: 0,
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
                  const SizedBox(height: 10),
                  Row(children: [
                    Text(
                        _localizeTagError(context, state.currentTag) ??
                            _localizeTagsError(context, state.selectedTags) ??
                            '',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ))
                  ]),
                  const SizedBox(height: 10),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      // Wait for the options
                      final options =
                          await _debouncedSearch.call(textEditingValue.text);

                      // If the options are null, return an empty list
                      if (options == null) {
                        return List<String>.empty();
                      }

                      return options;
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
                            message: context.loc.item_categories_search_tooltip,
                            child: IconButton(
                              isSelected: false,
                              onPressed: () {
                                _textEditingController.clear();
                                textEditingController.clear();
                              },
                              icon: const Icon(Icons.clear),
                              selectedIcon: const Icon(Icons.manage_search),
                            ),
                          )
                        ],
                        textInputAction: TextInputAction.done,
                        padding: const MaterialStatePropertyAll<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 16.0)),
                        onSubmitted: (String value) {
                          // Cancel the search
                          _debouncedSearch.cancel();

                          context.read<Step3Bloc>().add(AddTag(value));
                        },
                        onChanged: (String value) {
                          // pass changes to Autocomplete's controller
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
                  const SizedBox(
                    height: 10,
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
                                onDeleted: () =>
                                    context.read<Step3Bloc>().add(RemoveTag(v)),
                              ))
                          .toList(),
                    ),
                  )
                ],
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

  Future<List<String>> _search(String query) async {
    // Begin the searching task
    final task = _bloc.suggestTags(query);

    // Create searching event so the bloc can handle the state
    _bloc.add(SearchTagChanged(query, task));

    // Wait for the result
    final suggestedtags = await task;

    // Return the result
    return suggestedtags;
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
}
