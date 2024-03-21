part of 'step2_bloc.dart';

@immutable
abstract class Step2Event {
  const Step2Event();
}

class Step2InitialEvent extends Step2Event {
  const Step2InitialEvent();
}

class SelectedOptionsChanged extends Step2Event {
  final List<int> selectedOptions;

  const SelectedOptionsChanged(this.selectedOptions) : super();
}

class NextStepEvent extends Step2Event {
  const NextStepEvent();
}

class PreviousStepEvent extends Step2Event {
  const PreviousStepEvent();
}
