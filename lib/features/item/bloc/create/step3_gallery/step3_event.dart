part of 'step3_bloc.dart';

@immutable
abstract class Step3Event {
  const Step3Event();
}

class Step3InitialEvent extends Step3Event {
  const Step3InitialEvent();
}

class AddImage extends Step3Event {
  final File imageFile;

  const AddImage(this.imageFile) : super();
}

class RemoveImage extends Step3Event {
  final int index;

  const RemoveImage(this.index) : super();
}

class SetMainImage extends Step3Event {
  final int mainImageIndex;

  const SetMainImage(this.mainImageIndex) : super();
}

class NextStepEvent extends Step3Event {
  const NextStepEvent();
}

class PreviousStepEvent extends Step3Event {
  const PreviousStepEvent();
}
