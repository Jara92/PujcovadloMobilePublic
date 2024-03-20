part of 'step3_bloc.dart';

@immutable
class Step3State {
  final List<ItemImage> images;

  bool get maximumImagesExceeded => images.length >= ItemImage.maximumImages;

  /*final ItemImage? mainImage;*/
  final int? mainImageIndex;

  /* Always true because we dont require images */
  bool get isValid => true;

  const Step3State({
    this.images = const [],
    this.mainImageIndex,
  });

  Step3State copyWith({
    bool? isValid,
    List<ItemImage>? images,
    int? mainImage,
  }) {
    return Step3State(
      images: images ?? this.images,
      mainImageIndex: mainImage ?? this.mainImageIndex,
    );
  }
}

class InitialState extends Step3State {
  const InitialState() : super(images: const []);
}

class NextStepState extends Step3State {
  final int nextStep;

  const NextStepState({required this.nextStep}) : super();
}

class PreviousStepState extends Step3State {
  final int previousStep;

  const PreviousStepState({required this.previousStep}) : super();
}
