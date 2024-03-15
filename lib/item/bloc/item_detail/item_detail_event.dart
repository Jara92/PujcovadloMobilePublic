part of 'item_detail_bloc.dart';

@immutable
abstract class ItemDetailEvent {}

class LoadItemDetail extends ItemDetailEvent {
  final int itemId;

  LoadItemDetail({required this.itemId});
}
