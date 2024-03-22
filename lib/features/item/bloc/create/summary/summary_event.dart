part of 'summary_bloc.dart';

@immutable
abstract class SummaryEvent {
  const SummaryEvent();
}

class SummaryInitialEvent extends SummaryEvent {
  const SummaryInitialEvent() : super();
}

class TryAgainEvent extends SummaryEvent {
  const TryAgainEvent();
}

class NextStepEvent extends SummaryEvent {
  const NextStepEvent();
}

class PreviousStepEvent extends SummaryEvent {
  const PreviousStepEvent();
}
