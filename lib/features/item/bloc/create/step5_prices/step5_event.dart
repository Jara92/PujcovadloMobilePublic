part of 'step5_bloc.dart';

@immutable
abstract class Step5Event {
  const Step5Event();
}

class Step5InitialEvent extends Step5Event {
  const Step5InitialEvent();
}

class PricePerDayChanged extends Step5Event {
  final double? pricePerDay;

  const PricePerDayChanged(this.pricePerDay) : super();
}

class RefundableDepositChanged extends Step5Event {
  final double? refundableDeposit;

  const RefundableDepositChanged(this.refundableDeposit) : super();
}

class SellingPriceChanged extends Step5Event {
  final double? sellingPrice;

  const SellingPriceChanged(this.sellingPrice) : super();
}

class NextStepEvent extends Step5Event {
  const NextStepEvent();
}

class PreviousStepEvent extends Step5Event {
  const PreviousStepEvent();
}
