import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/location/location_bloc.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/item_form_heading.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
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
            return PopScope(
              canPop: false,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ItemFormHeading(
                        title: context.loc.item_location_title,
                        description: context.loc.item_location_description,
                      ),
                      Expanded(
                        child: state.latitude != null && state.longitude != null
                            ? MapLocationPicker(
                                currentLatLng: state.latitude != null &&
                                        state.longitude != null
                                    ? LatLng(state.latitude!, state.longitude!)
                                    : null,
                                searchHintText: context
                                    .loc.item_location_search_for_location,
                                hideMoreOptions: true,
                                hideBackButton: true,
                                hideBottomCard: true,
                                hasLocationPermission: true,
                                language: "cs",
                                components: [
                                  Component(Component.country, "cz")
                                ],
                                apiKey:
                                    "AIzaSyCOfLFiwnh1jEWgjB0udOrg97Fg7nqumgc",
                                onDecodeAddress: (GeocodingResult? location) {
                                  context.read<LocationBloc>().add(
                                        LocationChangedEvent(
                                          latitude:
                                              location?.geometry.location.lat,
                                          longitude:
                                              location?.geometry.location.lng,
                                        ),
                                      );
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ],
                  ),
                ),
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
