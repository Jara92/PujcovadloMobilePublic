import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  LocationBloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.state.data!;

    on<LocationInitialEvent>(_onInitialEvent);
    on<LocationChangedEvent>(_onLocationChanged);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  Future<void> _onInitialEvent(
      LocationInitialEvent event, Emitter<LocationState> emit) async {
    // Item already has location so we just use it
    if (_item.latitude != null && _item.longitude != null) {
      print("Initial location: ${_item.latitude}, ${_item.longitude}");

      emit(state.copyWith(
        latitude: _item.latitude,
        longitude: _item.longitude,
      ));

      return;
    }

    // We need permission to get current location
    await Geolocator.requestPermission();

    // get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Init selected categories
    emit(state.copyWith(
      latitude: position.latitude,
      longitude: position.longitude,
    ));
  }

  void _onLocationChanged(
      LocationChangedEvent event, Emitter<LocationState> emit) {
    // Ignore if location is not valid
    if (event.latitude == null || event.longitude == null) {
      return;
    }

    emit(state.copyWith(
      latitude: event.latitude,
      longitude: event.longitude,
    ));
  }

  void _onNextStep(NextStepEvent event, Emitter<LocationState> emit) {
    if (state.isValid) {
      _item.latitude = state.latitude;
      _item.longitude = state.longitude;

      _createItemBloc.add(const MoveToStepEvent(step4_gallery));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<LocationState> emit) {
    _createItemBloc.add(const MoveToStepEvent(step3_tags));
  }
}
