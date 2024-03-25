import 'package:formz/formz.dart';
import 'package:pujcovadlo_client/core/requests/image_request.dart';

enum ItemImageValidationError {
  required,
  invalid;

  const ItemImageValidationError();
}

class ItemImage extends FormzInput<ImageRequest, ItemImageValidationError> {
  static const int maximumImages = 8;

  const ItemImage.pure(super.value) : super.pure();

  const ItemImage.dirty(super.value) : super.dirty();

  @override
  ItemImageValidationError? validator(ImageRequest value) {
    /*if(value == null || value.path.isEmpty || File(value.path).existsSync() == false){
      return ItemImageValidationError.required;
    }*/

    return null;
  }
}
