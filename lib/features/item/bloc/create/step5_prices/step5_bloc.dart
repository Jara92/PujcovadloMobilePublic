import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:pujcovadlo_client/features/item/bloc/create/create_item_bloc.dart';
import 'package:pujcovadlo_client/features/item/models/models.dart';
import 'package:pujcovadlo_client/features/item/requests/item_request.dart';

part 'step5_event.dart';
part 'step5_state.dart';

class Step5Bloc extends Bloc<Step5Event, Step5State> {
  //late final ItemRequest item;
  late final CreateItemBloc _createItemBloc;
  late final ItemRequest _item;

  Step5Bloc(CreateItemBloc createItemBloc) : super(const InitialState()) {
    _createItemBloc = createItemBloc;
    _item = _createItemBloc.item;

    on<Step5InitialEvent>(_onInitialEvent);
    on<PricePerDayChanged>(_onPricePerDayChanged);
    on<RefundableDepositChanged>(_onRefundableDepositChanged);
    on<SellingPriceChanged>(_onSellingPriceChanged);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

  void _onInitialEvent(Step5InitialEvent event, Emitter<Step5State> emit) {
    emit(Step5State(
      pricePerDay: ItemPricePerDay.dirty(_item.pricePerDay),
      refundableDeposit: ItemRefundableDeposit.dirty(_item.refundableDeposit),
    ));
  }

  void _onPricePerDayChanged(
      PricePerDayChanged event, Emitter<Step5State> emit) {
    // Create new model and validate it
    final field = ItemPricePerDay.dirty(event.pricePerDay);

    // Emit new state
    emit(state.copyWith(
      pricePerDay: field,
    ));
  }

  void _onRefundableDepositChanged(
      RefundableDepositChanged event, Emitter<Step5State> emit) {
    // Create new model and validate it
    final field = ItemRefundableDeposit.dirty(event.refundableDeposit);

    // Emit new state
    emit(state.copyWith(
      refundableDeposit: field,
    ));
  }

  void _onSellingPriceChanged(
      SellingPriceChanged event, Emitter<Step5State> emit) {
    // Create new model and validate it
    final field = ItemSellingPrice.dirty(event.sellingPrice);

    // Emit new state
    emit(state.copyWith(
      sellingPrice: field,
    ));
  }

  void _onNextStep(NextStepEvent event, Emitter<Step5State> emit) {
    // Validate the form
    if (Formz.validate([
      state.pricePerDay,
      state.refundableDeposit,
      state.sellingPrice,
    ])) {
      _item.pricePerDay = state.pricePerDay.value;
      _item.refundableDeposit = state.refundableDeposit.value;
      _item.sellingPrice = state.sellingPrice.value;

      _createItemBloc.add(const MoveToStepEvent(step5_prices));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<Step5State> emit) {
    _createItemBloc.add(const MoveToStepEvent(step4_gallery));
  }
}
