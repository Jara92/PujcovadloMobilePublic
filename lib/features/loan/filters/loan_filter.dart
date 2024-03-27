class LoanFilter {
  String? search;

  String? tenantId;

  String? ownerId;

  LoanFilter({
    this.search,
    this.tenantId,
    this.ownerId,
  });

  Map<String, String?> toMap() {
    return {
      if (search != null) "search": search,
      if (ownerId != null) "ownerId": ownerId.toString(),
      if (tenantId != null) "tenantId": tenantId.toString(),
    };
  }
}
