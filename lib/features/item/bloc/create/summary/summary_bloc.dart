import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';
import 'package:pujcovadlo_client/features/item/services/item_service.dart';
import 'package:stream_transform/stream_transform.dart';

part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final ItemService _itemService = GetIt.instance.get<ItemService>();
  late final ItemRequest item;

  SummaryBloc(this.item) : super(const InitialState()) {
    on<SummaryInitialEvent>(_onInitialEvent);
    on<TryAgainEvent>(_onTryAgain,
        transformer:
            // Prevent multiple requests
            (events, mapper) => events
                .debounce(const Duration(milliseconds: 100))
                .switchMap(mapper));
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
    // Prevent multiple requests
    if (state is IsProcessing) return;

    emit(const IsProcessing());

    try {
      // We are updating if id is set
      if (item.id != null) {
        await _itemService.updateItem(item);
      }
      // We are creating new item
      else {
        var newItem = await _itemService.createItem(item);

        // Get new item id
        item.id = newItem.id;
      }

      // Emit success state and pass item id
      emit(SuccessState(itemId: item.id!));
    } on Exception catch (e) {
      print(e);
      emit(ErrorState(error: e));
    }
  }
}
