part of 'step4_bloc.dart';

@immutable
class Step4State {
  final List<ItemImage> images;

  bool get maximumImagesExceeded => images.length >= ItemImage.maximumImages;

  /*final ItemImage? mainImage;*/
  final int? mainImageIndex;

  /* True if maximum is not exceeded */
  bool get isValid => maximumImagesExceeded == false;

  const Step4State({
    this.images = const [],
    this.mainImageIndex,
  });

  Step4State copyWith({
    List<ItemImage>? images,
    int? mainImage,
  }) {
    return Step4State(
      images: images ?? this.images,
      mainImageIndex: mainImage ?? mainImageIndex,
    );
  }
}

class InitialState extends Step4State {
  const InitialState() : super(images: const []);
}
