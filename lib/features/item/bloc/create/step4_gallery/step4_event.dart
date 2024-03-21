part of 'step4_bloc.dart';

@immutable
abstract class Step4Event {
  const Step4Event();
}

class Step4InitialEvent extends Step4Event {
  const Step4InitialEvent();
}

class AddImage extends Step4Event {
  final File imageFile;

  const AddImage(this.imageFile) : super();
}

class RemoveImage extends Step4Event {
  final int index;

  const RemoveImage(this.index) : super();
}

class SetMainImage extends Step4Event {
  final int mainImageIndex;

  const SetMainImage(this.mainImageIndex) : super();
}

class NextStepEvent extends Step4Event {
  const NextStepEvent();
}

class PreviousStepEvent extends Step4Event {
  const PreviousStepEvent();
}
