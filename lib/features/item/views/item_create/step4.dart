import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pujcovadlo_client/core/custom_colors.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step4_gallery/step4_bloc.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_create/form_container.dart';
import 'package:pujcovadlo_client/features/item/widgets/item_placeholder_image.dart';
import 'package:transparent_image/transparent_image.dart';

class Step4 extends StatefulWidget {
  const Step4({super.key});

  @override
  State<Step4> createState() => _Step4State();
}

class _Step4State extends State<Step4> {
  late final ImagePicker _picker;

  Future<void> _addImageFromGallery(Function(File file) callback) async {
    try {
      // pickup multiple images
      final img = await _picker.pickMultiImage();

      // If the user picked images
      if (img.isNotEmpty) {
        // for each image call the callback
        for (var element in img) {
          callback(File(element.path));
        }
      }
    } catch (e) {
      // TODO: show error message
      print(e);
    }
  }

  Future<void> _addImageFromCamera(Function(File file) callback) async {
    try {
      // pickup image from camera
      final img = await _picker.pickImage(source: ImageSource.camera);

      // Call the callback if the image is not null
      if (img != null) {
        callback(File(img.path));
      }
    } catch (e) {
      // TODO: show error message
      print(e);
    }
  }

  Future _pickupImageDialog(Function(File file) callback) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text(context.loc.pick_from_gallery),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();

              // get image from gallery
              _addImageFromGallery(callback);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(context.loc.take_photo),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();

              // get image from camera
              _addImageFromCamera(callback);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Step4Bloc(context.read<CreateItemBloc>())
        ..add(const Step4InitialEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.title_create_new_item),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            // Todo: ask confirmation if there are unsaved changes
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<Step4Bloc, Step4State>(
          listener: (context, state) {},
          builder: (context, state) {
            return FormContainer(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.info_outline,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          context.loc.item_photo_gallery_title,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      ElevatedButton.icon(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: state.maximumImagesExceeded
                              ? null
                              : () async {
                                  _pickupImageDialog((file) => context
                                      .read<Step4Bloc>()
                                      .add(AddImage(file)));
                                },
                          label: Text(context.loc.add_photo))
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.loc.item_photo_gallery_description,
                          style: Theme.of(context).textTheme.labelSmall!,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (state.images.isNotEmpty)
                    _buildImageGallery(context, state)
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: BlocBuilder<Step4Bloc, Step4State>(
            builder: (context, state) {
              return Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: Text(context.loc.back),
                    onPressed: () => context
                        .read<Step4Bloc>()
                        .add(const PreviousStepEvent()),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(context.loc.next),
                    onPressed: state.isValid
                        ? () =>
                            context.read<Step4Bloc>().add(const NextStepEvent())
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

  Widget _buildImageGallery(BuildContext context, Step4State state) {
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: state.images
          // Filter out deleted images
          .where((img) => img.value.isDeleted == false)
          .toList()
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        // Get ItemRequest using model
        final img = entry.value.value;

        return Stack(children: <Widget>[
          Positioned.fill(
            child: img.isTemporary
                ? Image.file(
                    img.tmpFile!,
                    fit: BoxFit.cover,
                  )
                : FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: img.previewLink ?? '',
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        const ItemPlaceholderImage(fit: BoxFit.cover),
                  ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () =>
                      {context.read<Step4Bloc>().add(RemoveImage(index))},
                ),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: IconButton(
                  icon: Icon(
                      // Display full star if the image is the main image
                      index == state.mainImageIndex
                          ? Icons.star
                          : Icons.star_border_sharp),
                  color: CustomColors.gold,
                  onPressed: () =>
                      {context.read<Step4Bloc>().add(SetMainImage(index))},
                ),
              )),
          /* Display the Align only for the main image */
          if (index == state.mainImageIndex)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  context.loc.item_main_image,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            )
        ]);
      }).toList(),
    );
  }
}
