class ItemTagFilter {
  String? search;
  int? pageSize;

  ItemTagFilter({
    this.search,
    this.pageSize = 20,
  });

  Map<String, String?> toMap() {
    return {
      if (search != null) "search": search,
      if (pageSize != null) "pageSize": pageSize.toString(),
    };
  }
}
