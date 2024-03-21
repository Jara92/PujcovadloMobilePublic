import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step2_category_tags/step2_bloc.dart';

class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  late final MultiSelectController _categoriesController;

  @override
  void initState() {
    super.initState();
    _categoriesController = MultiSelectController();
  }

  @override
  void dispose() {
    _categoriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = Step2Bloc(context.read<CreateItemBloc>());
        bloc.add(const Step2InitialEvent());
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
        body: BlocConsumer<Step2Bloc, Step2State>(
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
                              context.loc.item_categories_page_title,
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
                              context.loc.item_categories_page_description,
                              style: Theme.of(context).textTheme.labelSmall!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      //SizedBox(height: 20),
                      Wrap(
                        direction: Axis.horizontal,
                        children: [
                          MultiSelectDropDown(
                            controller: _categoriesController,
                            searchLabel:
                                context.loc.item_categories_search_text,
                            hint: context.loc.item_categories_hint_text,
                            hintColor: Colors.black,
                            inputDecoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            //dropdownHeight: 300,
                            clearIcon: const Icon(Icons.close),
                            selectedOptionIcon: const Icon(Icons.check_circle),
                            onOptionSelected: (options) => context
                                .read<Step2Bloc>()
                                .add(SelectedOptionsChanged(options
                                    .map((e) => e.value as int)
                                    .toList())),
                            options: state.categories
                                .map((e) =>
                                    ValueItem(label: e.name, value: e.id))
                                .toList(),
                            maxItems: 10,
                            // TODO
                            searchEnabled: true,
                            selectionType: SelectionType.multi,
                            searchBackgroundColor: Colors.white,
                            dropdownBackgroundColor: Colors.white,
                            chipConfig: ChipConfig(
                              spacing: 10,
                              runSpacing: 0,
                              autoScroll: true,
                              //separator: Text("|"),
                              wrapType: WrapType.wrap,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 19,
                              ),
                              deleteIconColor: Colors.black87,
                              radius: 8,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 11),
                            ),
                            //dropdownHeight: 300,
                            optionTextStyle: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
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
