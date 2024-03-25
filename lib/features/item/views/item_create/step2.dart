import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/core/widgets/errors/no_search_results_error.dart';
import 'package:pujcovadlo_client/core/widgets/errors/operation_error.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step2_category_tags/step2_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/item_categories.dart';
import 'package:pujcovadlo_client/features/item/responses/item_category_response.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/form_container.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/item_form_heading.dart';

class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? _localizeCategoriesError(
      BuildContext context, ItemCategories categories) {
    if (categories.isPure || categories.isValid) {
      return null;
    }

    switch (categories.error) {
      case ItemCategoriesValidationError.tooManyCategories:
        return context.loc.item_categories_verror_too_many_categories;
      case ItemCategoriesValidationError.notEnoughtCategories:
        return context.loc.item_categories_verror_not_enough_categories;
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Step2Bloc(context.read<CreateItemBloc>())
        ..add(const Step2InitialEvent()),
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
            return FormContainer(
              child: Column(
                children: [
                  ItemFormHeading(
                    title: context.loc.item_categories_page_title,
                    description: context.loc.item_categories_page_description,
                    bottomMargin: 0,
                  ),
                  Row(
                    children: [
                      Text(
                        _localizeCategoriesError(
                                context, state.selectedCategories) ??
                            '',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SearchBar(
                    controller: _searchController,
                    leading: const Icon(Icons.search),
                    trailing: <Widget>[
                      Tooltip(
                        message: context.loc.item_categories_search_tooltip,
                        child: IconButton(
                          isSelected: false,
                          onPressed: () {
                            _searchController.clear();
                            context
                                .read<Step2Bloc>()
                                .add(const SearchTextUpdated(""));
                          },
                          icon: const Icon(Icons.clear),
                          selectedIcon: const Icon(Icons.manage_search),
                        ),
                      )
                    ],
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                    onChanged: (String value) {
                      context.read<Step2Bloc>().add(SearchTextUpdated(value));
                    },
                    hintText: context.loc.item_searching_in_categories,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        context.loc.item_selected_categories_count(
                            state.selectedCategories.value.length,
                            ItemCategories.maxCategoriesCount),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildMainBody(context, state),
                ],
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

  Widget _buildMainBody(BuildContext context, Step2State state) {
    if (state.status == Step2StateEnum.loaded) {
      return (state.categories.isEmpty)
          ? _buildEmptyMessage(context)
          : _buildCategoriesList(context, state);
    }

    if (state.status == Step2StateEnum.error) {
      return _buildFailedMessage(context);
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildEmptyMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 250,
          width: 250,
          child: NoSearchResultsError(
            message: context.loc.item_categories_no_seach_results,
          ),
        ),
      ],
    );
  }

  Widget _buildFailedMessage(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 250,
          width: 250,
          child: OperationError(
              onRetry: () =>
                  context.read<Step2Bloc>().add(const ReloadCategoriesEvent())),
        ),
      ],
    );
  }

  Widget _buildCategoriesList(BuildContext context, Step2State state) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 5.0,
        children: state.categories.map((ItemCategoryResponse category) {
          return FilterChip(
            label: Text(category.name),
            selected: state.selectedCategories.value.contains(category.id),
            onSelected: (bool selected) => context
                .read<Step2Bloc>()
                .add(CategoryOptionSelected(category.id, selected)),
          );
        }).toList(),
      ),
    );
  }
}
