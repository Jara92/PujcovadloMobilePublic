part of 'preview_bloc.dart';

@immutable
class PreviewState {
  final ItemRequest? data;

  bool get isDataSet => data != null;

  // No requirements here
  bool get isValid => true;

  const PreviewState({required this.data});

  PreviewState copyWith({
    ItemRequest? data,
  }) {
    return PreviewState(
      data: data ?? this.data,
    );
  }
}

class InitialState extends PreviewState {
  const InitialState({
    super.data,
  });
}
