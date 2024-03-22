part of 'summary_bloc.dart';

@immutable
class SummaryState {
  final bool isProcessing;

  // bool get isDataSet => data != null;

  const SummaryState({required this.isProcessing});
}

class InitialState extends SummaryState {
  const InitialState({
    super.isProcessing = false,
  });
}

class ErrorState extends SummaryState {
  final Exception error;

  const ErrorState({
    required this.error,
    super.isProcessing = false,
  });
}

class SuccessState extends SummaryState {
  final ItemResponse response;

  const SuccessState({
    required this.response,
    super.isProcessing = false,
  });
}

class IsProcessing extends SummaryState {
  const IsProcessing() : super(isProcessing: true);
}
