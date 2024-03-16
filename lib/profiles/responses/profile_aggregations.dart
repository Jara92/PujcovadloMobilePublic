class ProfileAggregations {
  int? countIfPublicItems;

  double? averageRating;

  int totalReviews;

  ProfileAggregations({
    this.countIfPublicItems,
    this.averageRating,
    this.totalReviews = 0,
  });

  factory ProfileAggregations.fromJson(Map<String, Object> json) {
    return ProfileAggregations(
      countIfPublicItems: json['countIfPublicItems'] as int?,
      averageRating: json['averageRating'] as double?,
      totalReviews: json['totalReviews'] as int,
    );
  }
}
