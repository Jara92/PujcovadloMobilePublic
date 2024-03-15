part of 'item_detail_bloc.dart';

@immutable
abstract class ItemDetailState {
  final bool isLoading;

  const ItemDetailState({required this.isLoading});
}

class ItemDetailInitial extends ItemDetailState {
  const ItemDetailInitial({super.isLoading = false});
}

class ItemDetailLoading extends ItemDetailState {
  const ItemDetailLoading({super.isLoading = true});
}

class ItemDetailLoaded extends ItemDetailState {
  final ItemDetailResponse item;


  const ItemDetailLoaded({required this.item, super.isLoading = false});
}

class ItemDetailNotFound extends ItemDetailState {
  const ItemDetailNotFound({super.isLoading = false});
}

class ItemDetailFailed extends ItemDetailState {
  final Exception error;

  const ItemDetailFailed({required this.error, super.isLoading = false});
}
