enum LoanStatus {
  inquired,
  accepted,
  denied,
  cancelled,
  preparedForPickup,
  pickupDenied,
  active,
  preparedForReturn,
  returnDenied,
  returned,
}

extension LoanStatusExtension on LoanStatus {
  int get value {
    switch (this) {
      case LoanStatus.inquired:
        return 1;
      case LoanStatus.accepted:
        return 2;
      case LoanStatus.denied:
        return 3;
      case LoanStatus.cancelled:
        return 4;
      case LoanStatus.preparedForPickup:
        return 5;
      case LoanStatus.pickupDenied:
        return 6;
      case LoanStatus.active:
        return 7;
      case LoanStatus.preparedForReturn:
        return 8;
      case LoanStatus.returnDenied:
        return 9;
      case LoanStatus.returned:
        return 10;
    }
  }

  static LoanStatus fromValue(int value) {
    switch (value) {
      case 1:
        return LoanStatus.inquired;
      case 2:
        return LoanStatus.accepted;
      case 3:
        return LoanStatus.denied;
      case 4:
        return LoanStatus.cancelled;
      case 5:
        return LoanStatus.preparedForPickup;
      case 6:
        return LoanStatus.pickupDenied;
      case 7:
        return LoanStatus.active;
      case 8:
        return LoanStatus.preparedForReturn;
      case 9:
        return LoanStatus.returnDenied;
      case 10:
        return LoanStatus.returned;
      default:
        throw ArgumentError('Invalid value for LoanStatus: $value');
    }
  }
}
