import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/core/requests/image_request.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';

part 'step3_event.dart';
part 'step3_state.dart';

class Step3Bloc extends Bloc<Step3Event, Step3State> {
  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  Step3Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.item;

    on<Step3InitialEvent>(_onInitialEvent);
    on<AddImage>(_onAddImage);
    on<RemoveImage>(_onRemoveImage);
    on<SetMainImage>(_onSetMainImage);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  Future<void> _onInitialEvent(
      Step3InitialEvent event, Emitter<Step3State> emit) async {
    // TODO
    List<ItemImage> images = [];

    emit(state.copyWith(images: images));
  }

  void _onAddImage(AddImage event, Emitter<Step3State> emit) {
    final images = state.images;

    // If the maximum number of images is reached, do nothing
    if (images.length >= ItemImage.maximumImages) {
      return;
    }

    // validate new image
    var newImage = ItemImage.dirty(event.imageFile);
    if (!Formz.validate([newImage])) {
      // Do nothing if the image is not valid
      return;
    }

    // Add the image and update the state
    images.add(newImage);
    emit(state.copyWith(images: images));

    // If the main image is not set, set the added image as the main image
    if (state.mainImageIndex == null) {
      emit(state.copyWith(mainImage: state.images.length - 1));
    }
  }

  void _onRemoveImage(RemoveImage event, Emitter<Step3State> emit) {
    // print("removing image at index ${event.index}");

    final images = state.images;

    // if the index is valid
    if (images.length > event.index) {
      //print("removing image at index ${event.index}");
      // Remove the image and update the state
      images.removeAt(event.index);
      emit(state.copyWith(images: images));

      // If the removed image was the main image
      if (event.index == state.mainImageIndex) {
        // If there are still images, set the first one as the main image
        if (images.isNotEmpty) {
          emit(state.copyWith(mainImage: 0));
        }
        // If there are no images, set the main image to null
        else {
          emit(state.copyWith(mainImage: null));
        }
      }
    }
  }

  void _onSetMainImage(SetMainImage event, Emitter<Step3State> emit) {
    emit(state.copyWith(mainImage: event.mainImageIndex));
  }

  void _onNextStep(NextStepEvent event, Emitter<Step3State> emit) {
    if (true) {
      // Set images to the item
      _item.images = state.images
          .map((img) => ImageRequest(
                tmpFile: img.value,
              ))
          .toList();

      // Set main image to the item
      _item.mainImage = state.mainImageIndex != null
          ? _item.images[state.mainImageIndex!]
          : null;

      _createItemBloc.add(const MoveToStepEvent(step2_category_and_tags));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step3State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step1_name_and_description));
  }
}
