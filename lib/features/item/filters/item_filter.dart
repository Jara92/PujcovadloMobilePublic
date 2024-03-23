class ItemFilter {
  int? ownerId;
  int? pageSize;

  ItemFilter({
    this.ownerId,
    this.pageSize = 20,
  });

  Map<String, String?> toMap() {
    return {
      if (ownerId != null) "ownerId": ownerId.toString(),
      if (pageSize != null) "pageSize": pageSize.toString(),
    };
  }
}
