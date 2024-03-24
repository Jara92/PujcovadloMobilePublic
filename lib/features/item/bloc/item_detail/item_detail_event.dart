part of 'item_detail_bloc.dart';

@immutable
abstract class ItemDetailEvent {}

class LoadItemDetail extends ItemDetailEvent {
  final int? itemId;
  final ItemResponse? item;

  LoadItemDetail({this.itemId, this.item});
}
