import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/location/location_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/form_container.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/item_form_heading.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final _controllerName = TextEditingController();
  final _controllerDescription = TextEditingController();

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
    return BlocProvider(
      create: (context) => LocationBloc(context.read<CreateItemBloc>())
        ..add(const LocationInitialEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.title_create_new_item),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            // Todo: ask confirmation if there are unsaved changes
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<LocationBloc, LocationState>(
          listener: (BuildContext context, LocationState state) {},
          builder: (BuildContext context, LocationState state) {
            return FormContainer(
              child: Column(
                children: [
                  ItemFormHeading(
                    title: context.loc.item_name_and_description_title,
                    description:
                        context.loc.item_name_and_description_description,
                  )
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              return Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: Text(context.loc.back),
                    onPressed: () => context
                        .read<LocationBloc>()
                        .add(const PreviousStepEvent()),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(context.loc.next),
                    // Allow to go to the next step only if the form is valid
                    onPressed: state.isValid
                        ? () {
                            context
                                .read<LocationBloc>()
                                .add(const NextStepEvent());
                          }
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
