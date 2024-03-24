import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';
import 'package:pujcovadlo_client/features/item/responses/item_response.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';

part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final ItemService _itemService = ItemService();
  late final ItemRequest item;

  SummaryBloc(this.item) : super(const InitialState()) {
    on<SummaryInitialEvent>(_onInitialEvent);
    on<TryAgainEvent>(_onTryAgain);
  }

  Future<void> _onInitialEvent(
      SummaryInitialEvent event, Emitter<SummaryState> emit) async {
    // try to save the item
    await _saveItem(event, emit);
  }

  Future<void> _onTryAgain(
      TryAgainEvent event, Emitter<SummaryState> emit) async {
    // try to save the item
    await _saveItem(event, emit);
  }

  Future<void> _saveItem(SummaryEvent event, Emitter<SummaryState> emit) async {
    emit(const IsProcessing());

    try {
      final response = await _trySave(item);

      // TODO: Dont pass full response because when updating we dont have all the data
      emit(SuccessState(response: response));
    } on Exception catch (e) {
      emit(ErrorState(error: e));
    }
  }

  Future<ItemResponse> _trySave(ItemRequest request) async {
    return _itemService.createItem(request);
  }
}
