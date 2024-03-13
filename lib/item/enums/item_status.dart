enum ItemStatus { public, denied, approving, deleted }

extension ItemStatusExtension on ItemStatus {
  int get value {
    switch (this) {
      case ItemStatus.public:
        return 1;
      case ItemStatus.denied:
        return 2;
      case ItemStatus.approving:
        return 3;
      case ItemStatus.deleted:
        return 4;
    }
  }

  static ItemStatus fromValue(int value) {
    switch (value) {
      case 1:
        return ItemStatus.public;
      case 2:
        return ItemStatus.denied;
      case 3:
        return ItemStatus.approving;
      case 4:
        return ItemStatus.deleted;
      default:
        throw ArgumentError('Invalid value for ItemStatus: $value');
    }
  }
}
