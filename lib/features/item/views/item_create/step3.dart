import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/chips_input.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step3_tags/step3_bloc.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {

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
                      ChipsInput<String>(
                        values: state.selectedTags,
                        decoration: InputDecoration(
                          /*prefixIcon: Icon(Icons.local_pizza_rounded),*/
                          labelText: context.loc.item_tags_title,
                          hintText: context.loc.item_tags_search_text,
                          //helperText: context.loc.item_tags_helper_text,
                          helperMaxLines: 2,
                          border: OutlineInputBorder(),
                        ),
                        strutStyle: const StrutStyle(fontSize: 15),
                        onChanged: (List<String> tags) => context
                            .read<Step3Bloc>()
                            .add(SelectedTagsChanged(tags)),
                        onSubmitted: (String tag) =>
                            context.read<Step3Bloc>().add(AddTag(tag)),
                        /*onTapOutside: (event) =>
                            context.read<Step3Bloc>().add(const ClearSuggestions()),*/
                        chipBuilder: _chipBuilder,
                        onTextChanged: (String value) => context
                            .read<Step3Bloc>()
                            .add(SearchTagChanged(value)),
                      ),
                      if (state.suggestedTags.isNotEmpty)
                        Material(
                          color: Colors.white,
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0),
                            ),
                          ),
                          shadowColor: Colors.black,
                          child: Container(
                            height: 300,
                            color: Colors.white,
                            child: ListView.builder(
                              itemCount: state.suggestedTags.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ChipsSuggestion(
                                    state.suggestedTags[index],
                                    onTap: (String tag) => context
                                        .read<Step3Bloc>()
                                        .add(SelectSuggestion(tag)));
                              },
                            ),
                          ),
                        ),
                      // tags
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

  Widget _chipBuilder(BuildContext context, String tag) {
    return InputChipTile(
      value: tag,
      onDeleted: (String tag) => context.read<Step3Bloc>().add(RemoveTag(tag)),
      onSelected: (String tag) {},
    );
  }
}
