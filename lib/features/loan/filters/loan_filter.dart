class LoanFilter {
  String? search;

  String? tenantId;

  String? ownerId;

  int? pageSize;

  LoanFilter({
    this.search,
    this.tenantId,
    this.ownerId,
    this.pageSize = 10,
  });

  Map<String, String?> toMap() {
    return {
      if (search != null) "search": search,
      if (ownerId != null) "ownerId": ownerId.toString(),
      if (tenantId != null) "tenantId": tenantId.toString(),
      if (pageSize != null) "pageSize": pageSize.toString(),
    };
  }
}
