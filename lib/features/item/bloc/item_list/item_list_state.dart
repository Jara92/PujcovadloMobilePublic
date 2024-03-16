part of 'item_list_bloc.dart';

@immutable
abstract class ItemListState {
  final bool isLoading;
  final List<ItemResponse> items;

  const ItemListState({this.isLoading = false, this.items = const <ItemResponse>[]});
}

class ItemListInitial extends ItemListState {
  const ItemListInitial({super.isLoading, super.items});
}

class ItemListLoading extends ItemListState {
  const ItemListLoading({super.isLoading});
}

class ItemListLoaded extends ItemListState {
  const ItemListLoaded({super.isLoading, required super.items});
}
