class ItemFilter {
  String? search;
  String? ownerId;
  int? pageSize;
  int? status;

  ItemFilter({
    this.search,
    this.ownerId,
    this.pageSize = 10,
    this.status,
  });

  Map<String, String?> toMap() {
    return {
      if (search != null) "search": search,
      if (ownerId != null) "ownerId": ownerId.toString(),
      if (pageSize != null) "pageSize": pageSize.toString(),
      if (status != null) "status": status.toString(),
    };
  }
}
