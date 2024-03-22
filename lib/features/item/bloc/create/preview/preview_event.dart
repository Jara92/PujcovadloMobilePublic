part of 'preview_bloc.dart';

@immutable
abstract class PreviewEvent {
  const PreviewEvent();
}

class PreviewUpdate extends PreviewEvent {
  const PreviewUpdate() : super();
}

class NextStepEvent extends PreviewEvent {
  const NextStepEvent();
}

class PreviousStepEvent extends PreviewEvent {
  const PreviousStepEvent();
}
