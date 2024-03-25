import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/requests/image_request.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';

part 'step4_event.dart';
part 'step4_state.dart';

class Step4Bloc extends Bloc<Step4Event, Step4State> {
  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  Step4Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.state.data!;

    on<Step4InitialEvent>(_onInitialEvent);
    on<AddImage>(_onAddImage);
    on<RemoveImage>(_onRemoveImage);
    on<SetMainImage>(_onSetMainImage);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  Future<void> _onInitialEvent(
      Step4InitialEvent event, Emitter<Step4State> emit) async {
    // Convert existing images to ItemImage models
    final itemImages = _item.images.map((img) => ItemImage.pure(img)).toList();

    // Set the main image index
    final mainImageIndex = _item.mainImage != null
        ? _item.images.indexWhere((img) => img.id == _item.mainImage!.id)
        : null;

    // Emit state with existing images
    emit(state.copyWith(
        images: itemImages, mainImageIndex: () => mainImageIndex));
  }

  void _onAddImage(AddImage event, Emitter<Step4State> emit) {
    final images = state.images;

    // If the maximum number of images is reached, do nothing
    if (images.length >= ItemImage.maximumImages) {
      return;
    }

    // validate new image
    var newImage = ItemImage.dirty(ImageRequest.fromFile(event.imageFile));
    if (!Formz.validate([newImage])) {
      // Do nothing if the image is not valid
      return;
    }

    // Add the image and update the state
    images.add(newImage);
    emit(state.copyWith(images: images));

    // If the main image is not set, set the added image as the main image
    if (state.mainImageIndex == null) {
      emit(state.copyWith(mainImageIndex: () => state.images.length - 1));
    }
  }

  void _onRemoveImage(RemoveImage event, Emitter<Step4State> emit) {
    final images = state.images;

    // Do nothing if the index is invalid
    if (images.length <= event.index) return;

    // Remove the image and update the state
    final imageToRemove = images[event.index];

    // Remove the image from the list if the file is just temporary
    if (imageToRemove.value.isTemporary) {
      imageToRemove.value.tmpFile!.delete();
      images.removeAt(event.index);
    } else {
      // Mark the image as deleted
      images[event.index].value.isDeleted = true;
    }

    // Update the state
    emit(state.copyWith(images: images));

    // If the removed image was the main image
    if (event.index == state.mainImageIndex) {
      // Find the first image that is not deleted
      final newMainImage =
          state.images.where((img) => img.value.isDeleted == false).firstOrNull;

      // Set the new main image index
      emit(state.copyWith(
          mainImageIndex: () => newMainImage != null
              ? state.images.indexWhere((img) => img == newMainImage)
              : null));
    }
  }

  void _onSetMainImage(SetMainImage event, Emitter<Step4State> emit) {
    emit(state.copyWith(mainImageIndex: () => event.mainImageIndex));
  }

  void _onNextStep(NextStepEvent event, Emitter<Step4State> emit) {
    if (state.isValid) {
      // Set images to the item
      _item.images = state.images
          // Get the value of the image
          .map((img) => img.value)
          .toList();

      // Set main image to the item
      _item.mainImage = state.mainImageIndex != null
          ? _item.images[state.mainImageIndex!]
          : null;

      _createItemBloc.add(const MoveToStepEvent(step5_prices));
    }

    // TODO: remove physical files after they are uploaded
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step4State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step3_tags));
  }
}
