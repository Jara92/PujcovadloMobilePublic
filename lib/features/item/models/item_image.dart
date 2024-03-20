import 'dart:io';

import 'package:formz/formz.dart';

enum ItemImageValidationError {
  required,
  invalid;

  const ItemImageValidationError();
}

class ItemImage extends FormzInput<File?, ItemImageValidationError> {
  static const int maximumImages = 8;

  final bool isMainImage = false;

  const ItemImage.pure([super.value]) : super.pure();

  const ItemImage.dirty([super.value]) : super.dirty();

  @override
  ItemImageValidationError? validator(File? value) {
    /*if(value == null || value.path.isEmpty || File(value.path).existsSync() == false){
      return ItemImageValidationError.required;
    }*/

    return null;
  }
}
