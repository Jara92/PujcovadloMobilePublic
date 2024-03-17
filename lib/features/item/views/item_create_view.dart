import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';

class ItemCreateView extends StatelessWidget {
  const ItemCreateView({super.key});

  String? _localizeItemNameError(BuildContext context, ItemName name) {
    if (name.isPure || name.isValid) {
      return null;
    }

    switch (name.error) {
      case ItemNameValidationError.required:
        return context.loc.verror_this_field_is_required;
      case ItemNameValidationError.invalid:
        return context.loc.verror_input_invalid;
      case ItemNameValidationError.tooShort:
        return context.loc.verror_input_too_short;
      case ItemNameValidationError.tooLong:
        return context.loc.verror_input_too_long;
      case null:
        return null;
    }
  }

  String? _localizeItemDescriptionError(
      BuildContext context, ItemDescription description) {
    if (description.isPure || description.isValid) {
      return null;
    }

    switch (description.error) {
      case ItemDescriptionValidationError.required:
        return context.loc.verror_this_field_is_required;
      case ItemDescriptionValidationError.invalid:
        return context.loc.verror_input_invalid;
      case ItemDescriptionValidationError.tooShort:
        return context.loc.verror_input_too_short;
      case ItemDescriptionValidationError.tooLong:
        return context.loc.verror_input_too_long;
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.title_create_new_item),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          // Todo: ask confirmation if there are unsaved changes
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocProvider(
              create: (context) {
                var bloc = CreateItemBloc();
                bloc.add(const InitialEvent());
                return bloc;
              },
              child: BlocConsumer<CreateItemBloc, CreateItemState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is Step1_NameAndDescription) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Theme.of(context).primaryColor),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                context.loc.item_name_and_description_title,
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
                                context
                                    .loc.item_name_and_description_description,
                                style: Theme.of(context).textTheme.labelSmall!,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (String value) {
                                  BlocProvider.of<CreateItemBloc>(context)
                                      .add(ItemNameChanged(value));
                                },
                                maxLength: 30,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  labelText: context.loc.item_name_title,
                                  hintText: context.loc.item_name_hint_text,
                                  helperText: context.loc.item_name_helper_text,
                                  // error because we dont know that the state is Step1_NameAndDescription
                                  errorText: _localizeItemNameError(
                                      context, state.name),
                                  border: OutlineInputBorder(),
                                  //border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (String value) {
                                  BlocProvider.of<CreateItemBloc>(context)
                                      .add(ItemDescriptionChanged(value));
                                },
                                maxLength: 500,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                keyboardType: TextInputType.multiline,
                                minLines: 3,
                                // Set this
                                maxLines: 7,
                                //
                                decoration: InputDecoration(
                                  labelText: context.loc.item_description_title,
                                  hintText:
                                      context.loc.item_description_hint_text,
                                  helperText:
                                      context.loc.item_description_helper_text,
                                  helperMaxLines: 3,
                                  errorText: _localizeItemDescriptionError(
                                      context, state.description),
                                  border: OutlineInputBorder(),
                                  //border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                BlocProvider.of<CreateItemBloc>(context)
                                    .add(const Step1SubmitEvent());
                              },
                              icon: const Icon(Icons.next_plan_rounded),
                              label: Text(context.loc.next),
                            )
                          ],
                        )
                      ],
                    );
                  }

                  return Row();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
