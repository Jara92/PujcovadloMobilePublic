part of 'my_item_list_bloc.dart';

@immutable
abstract class MyItemListState {
  final bool isLoading;
  final List<ItemResponse> items;

  const MyItemListState({this.isLoading = false, this.items = const []});
}

class InitialState extends MyItemListState {
  const InitialState({super.isLoading, super.items});
}

class LoadingState extends MyItemListState {
  const LoadingState({super.isLoading = true});
}

class LoadedState extends MyItemListState {
  const LoadedState({super.isLoading, required super.items});
}

class ErrorState extends MyItemListState {
  final Exception error;

  const ErrorState({super.isLoading, super.items, required this.error});
}
