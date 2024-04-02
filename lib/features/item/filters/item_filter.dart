class ItemFilter {
  String? search;
  String? ownerId;
  int? pageSize;
  int? status;

  double? latitude;
  double? longitude;

  ItemFilter({
    this.search,
    this.ownerId,
    this.pageSize = 10,
    this.status,
    this.latitude,
    this.longitude,
  });

  Map<String, String?> toMap() {
    return {
      if (search != null) "search": search,
      if (ownerId != null) "ownerId": ownerId.toString(),
      if (pageSize != null) "pageSize": pageSize.toString(),
      if (status != null) "status": status.toString(),
      if (latitude != null) "latitude": latitude.toString(),
      if (longitude != null) "longitude": longitude.toString(),
    };
  }
}
