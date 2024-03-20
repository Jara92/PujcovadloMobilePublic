import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pujcovadlo_client/core/extensions/buildcontext/loc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/step3_gallery/step3_bloc.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  List<XFile> _images = [];

  Future<void> _addImageFromGallery() async {
    try {
      //final img = await _picker.pickImage(source: ImageSource.gallery);
      final img = await _picker.pickMultiImage();

      setState(() {
        //_image = img;
        if (img.isNotEmpty) {
          //_images.add(img);
          //_images.addAll(img);
          for (var element in img) {
            _images.add(element);
          }
        }
      });
    } catch (e) {
      // TODO: show error message
      print(e);
    }
  }

  Future<void> _addImageFromCamera() async {
    try {
      final img = await _picker.pickImage(source: ImageSource.camera);

      setState(() {
        _image = img;
        if (img != null) {
          _images.add(img);
        }
      });
    } catch (e) {
      // TODO: show error message
      print(e);
    }
  }

  Future showOptions() async {
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
              _addImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(context.loc.take_photo),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              _addImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

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
                              context.loc.item_photo_gallery_title,
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
                              context.loc.item_photo_gallery_description,
                              style: Theme.of(context).textTheme.labelSmall!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () async {
                            showOptions();
                          },
                          child: Text(context.loc.add_photo)),
                      const SizedBox(height: 20),
                      if (_images.isNotEmpty)
                        GridView.count(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            physics: const NeverScrollableScrollPhysics(),
                            children: _images
                                .map((img) => Image.file(
                                      File(img.path),
                                      fit: BoxFit.cover,
                                    ))
                                .toList()),
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
}
