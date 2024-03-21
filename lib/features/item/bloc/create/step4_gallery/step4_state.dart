part of 'step4_bloc.dart';

@immutable
class Step4State {
  final List<ItemImage> images;

  bool get maximumImagesExceeded => images.length >= ItemImage.maximumImages;

  /*final ItemImage? mainImage;*/
  final int? mainImageIndex;

  /* Always true because we dont require images */
  bool get isValid => true;

  const Step4State({
    this.images = const [],
    this.mainImageIndex,
  });

  Step4State copyWith({
    bool? isValid,
    List<ItemImage>? images,
    int? mainImage,
  }) {
    return Step4State(
      images: images ?? this.images,
      mainImageIndex: mainImage ?? this.mainImageIndex,
    );
  }
}

class InitialState extends Step4State {
  const InitialState() : super(images: const []);
}

/*
class NextStepState extends Step4State {
  final int nextStep;

  const NextStepState({required this.nextStep}) : super();
}

class PreviousStepState extends Step4State {
  final int previousStep;

  const PreviousStepState({required this.previousStep}) : super();
}
*/
