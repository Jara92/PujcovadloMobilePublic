part of 'step4_bloc.dart';

@immutable
class Step4State {
  final List<ItemImage> images;

  bool get canAddMoreImages =>
      images.where((i) => i.value.isDeleted == false).length <
      ItemImage.maximumImages;

  bool get maximumImagesExceeded =>
      images.where((i) => i.value.isDeleted == false).length >
      ItemImage.maximumImages;

  final int? mainImageIndex;

  /* True if maximum is not exceeded */
  bool get isValid => maximumImagesExceeded == false;

  const Step4State({
    this.images = const [],
    this.mainImageIndex,
  });

  Step4State copyWith({
    List<ItemImage>? images,
    // "Function()?" stuff allows to set null value if we need too
    int? Function()? mainImageIndex,
  }) {
    return Step4State(
      images: images ?? this.images,
      mainImageIndex:
          mainImageIndex != null ? mainImageIndex() : this.mainImageIndex,
    );
  }
}

class InitialState extends Step4State {
  const InitialState() : super(images: const []);
}
