part of 'step5_bloc.dart';

@immutable
class Step5State {
  final ItemPricePerDay pricePerDay;
  final ItemRefundableDeposit refundableDeposit;
  final ItemSellingPrice sellingPrice;

  bool get isValid => Formz.validate([
        pricePerDay,
        refundableDeposit,
        sellingPrice,
      ]);

  const Step5State({
    this.pricePerDay = const ItemPricePerDay.pure(),
    this.refundableDeposit = const ItemRefundableDeposit.pure(),
    this.sellingPrice = const ItemSellingPrice.pure(),
  });

  Step5State copyWith({
    ItemPricePerDay? pricePerDay,
    ItemRefundableDeposit? refundableDeposit,
    ItemSellingPrice? sellingPrice,
  }) {
    return Step5State(
      pricePerDay: pricePerDay ?? this.pricePerDay,
      refundableDeposit: refundableDeposit ?? this.refundableDeposit,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }
}

class InitialState extends Step5State {
  const InitialState({
    super.pricePerDay,
    super.refundableDeposit,
    super.sellingPrice,
  });
}
